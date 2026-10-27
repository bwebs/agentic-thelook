include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"

view: event_step_transitions {
  extends: [events]
  label: "Event Step Transitions"

  derived_table: {
    sql:
      SELECT
        {{ id._sql }} AS id,
        COALESCE(
          LEAD({{ event_type._sql }}) OVER (
            PARTITION BY {{ session_id._sql }}
            ORDER BY {{ sequence_number._sql }} ASC, {{ created_raw._sql }} ASC
          ),
          'SESSION_EXIT'
        ) AS to_state,
        TIMESTAMP_DIFF(
          LEAD({{ created_raw._sql }}) OVER (
            PARTITION BY {{ session_id._sql }}
            ORDER BY {{ sequence_number._sql }} ASC, {{ created_raw._sql }} ASC
          ),
          {{ created_raw._sql }},
          SECOND
        ) AS step_dwell_seconds
      FROM ${events.SQL_TABLE_NAME} AS {{ _table }} ;;
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: to_state {
    label: "Next Step or Session Exit State"
    description: "Next page event_type visited within the session, or 'SESSION_EXIT' when the shopper exits after the current step."
    synonyms: ["to state", "next step state", "destination event state"]
    type: string
    sql: ${TABLE}.to_state ;;
  }

  dimension: step_dwell_seconds {
    label: "Step Dwell Time (Seconds)"
    description: "Elapsed seconds spent on the current page step before moving to the next event in the session (NULL on session exit)."
    synonyms: ["step dwell seconds", "seconds on step"]
    type: number
    sql: ${TABLE}.step_dwell_seconds ;;
  }

  measure: _avg_step_dwell_seconds {
    hidden: yes
    tags: ["non_additive"]
    type: average
    sql: ${step_dwell_seconds} ;;
  }

  measure: avg_seconds_before_transition {
    label: "Average Seconds Before Transition"
    description: "Mean seconds spent on the step before transitioning to the destination state (0 for SESSION_EXIT)."
    synonyms: ["avg seconds before transition", "average step dwell seconds"]
    tags: ["non_additive"]
    type: number
    sql: COALESCE(${_avg_step_dwell_seconds}, 0) ;;
    value_format_name: decimal_1
  }
}
