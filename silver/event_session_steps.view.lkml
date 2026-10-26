include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"

view: event_session_steps {
  extends: [events]
  label: "Event Session Steps"

  derived_table: {
    sql:
      SELECT
        {{ id._sql }} AS id,
        ROW_NUMBER() OVER (
          PARTITION BY {{ session_id._sql }}
          ORDER BY {{ sequence_number._sql }} ASC, {{ created_raw._sql }} ASC
        ) AS step_asc,
        ROW_NUMBER() OVER (
          PARTITION BY {{ session_id._sql }}
          ORDER BY {{ sequence_number._sql }} DESC, {{ created_raw._sql }} DESC
        ) AS step_desc,
        COUNT({{ id._sql }}) OVER (
          PARTITION BY {{ session_id._sql }}
        ) AS session_total_events
      FROM ${events.SQL_TABLE_NAME} AS {{ _table }} ;;
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: step_asc {
    label: "Session Step (Ascending)"
    description: "1-based chronological click position of the event within its browsing session (ordered by sequence_number ASC, created_at ASC)."
    synonyms: ["session step asc", "forward session step"]
    type: number
    sql: ${TABLE}.step_asc ;;
  }

  dimension: step_desc {
    label: "Session Step (Reverse)"
    description: "1-based reverse-chronological click position of the event from the end of its browsing session (1 = final event in session)."
    synonyms: ["session step desc", "reverse session step"]
    type: number
    sql: ${TABLE}.step_desc ;;
  }

  dimension: session_total_events {
    label: "Session Total Events"
    description: "Total number of clickstream events recorded across the event's entire browsing session."
    synonyms: ["events in session", "session click count"]
    type: number
    sql: ${TABLE}.session_total_events ;;
  }

  dimension: session_structural_role {
    label: "First-Touch versus Last-Touch Session Event Role"
    description: "First-Touch versus Last-Touch Session Event Role tags every click inside a browsing session according to its position in the visit: 'Solo Single-Click Bounce Event', 'Doorway Opener (Session First Touch)', 'Middle-Funnel Meandering Step', or 'Curtain Closer (Session Last Touch)'. Web analysts use this structural role to separate entry landing pages that attract visitors from exit screens where shoppers drop off."
    synonyms: ["session structural role", "first-touch vs last-touch role", "session event role", "entry vs exit event role"]
    case: {
      when: {
        sql: ${session_total_events} = 1 ;;
        label: "Solo Single-Click Bounce Event"
      }
      when: {
        sql: ${step_asc} = 1 ;;
        label: "Doorway Opener (Session First Touch)"
      }
      when: {
        sql: ${step_desc} > 1 ;;
        label: "Middle-Funnel Meandering Step"
      }
      else: "Curtain Closer (Session Last Touch)"
    }
  }
}
