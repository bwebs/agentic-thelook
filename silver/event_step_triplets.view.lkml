include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"

view: event_step_triplets {
  extends: [events]
  label: "Event Step Triplets"

  derived_table: {
    sql:
      SELECT
        {{ id._sql }} AS id,
        LAG({{ event_type._sql }}) OVER (
          PARTITION BY {{ session_id._sql }}
          ORDER BY {{ sequence_number._sql }}
        ) AS prev_event_type,
        {{ event_type._sql }} AS curr_event_type,
        LEAD({{ event_type._sql }}) OVER (
          PARTITION BY {{ session_id._sql }}
          ORDER BY {{ sequence_number._sql }}
        ) AS next_event_type
      FROM ${events.SQL_TABLE_NAME} AS {{ _table }} ;;
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: prev_event_type {
    label: "Previous Session Event Type"
    group_label: "Session Step Triplets"
    description: "Event type immediately preceding the current click within the same browsing session (ordered by sequence_number)."
    synonyms: ["prev event", "previous event type", "prior step event"]
    type: string
    sql: ${TABLE}.prev_event_type ;;
  }

  dimension: next_event_type {
    label: "Next Session Event Type"
    group_label: "Session Step Triplets"
    description: "Event type immediately following the current click within the same browsing session (ordered by sequence_number)."
    synonyms: ["next event", "following event type", "subsequent step event"]
    type: string
    sql: ${TABLE}.next_event_type ;;
  }

  dimension: oscillation_triplet {
    label: "Clickstream Step Triplet"
    group_label: "Session Step Triplets"
    description: "Three-step consecutive session transition formatted as 'prev_event -> curr_event -> next_event' for interior session steps."
    synonyms: ["step triplet", "event transition triplet", "pogo-stick triplet"]
    type: string
    sql: CONCAT(${prev_event_type}, ' -> ', ${TABLE}.curr_event_type, ' -> ', ${next_event_type}) ;;
  }

  dimension: is_pogo_stick_oscillation {
    label: "Pogo-Stick Oscillation Step"
    group_label: "Session Step Triplets"
    description: "Whether the click represents an A -> B -> A session backtrack where the previous and next event types match and differ from the current event type."
    synonyms: ["is pogo stick bounce", "a-b-a backtrack step", "oscillation bounce"]
    type: yesno
    sql: ${prev_event_type} = ${next_event_type}
      AND ${prev_event_type} IS NOT NULL
      AND ${TABLE}.curr_event_type != ${prev_event_type} ;;
  }

  measure: pogo_stick_oscillations {
    label: "Pogo-Stick Oscillation Bounces"
    description: "Count of A -> B -> A pogo-sticking oscillation steps where a shopper bounced from an event type to another screen and immediately back."
    synonyms: ["pogo stick oscillations", "backtrack bounces", "indecision oscillations"]
    type: count
    filters: [is_pogo_stick_oscillation: "yes"]
  }
}
