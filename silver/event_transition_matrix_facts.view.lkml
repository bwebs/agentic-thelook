include: "/silver/explores/events.explore.lkml"

view: event_transition_matrix_facts {
  label: "Clickstream Step Transition Matrix"

  derived_table: {
    explore_source: events {
      column: from_state { field: events.event_type }
      column: to_state { field: event_step_transitions.to_state }
      column: transition_count { field: events.count }
      column: avg_dwell_sec { field: event_step_transitions.avg_seconds_before_transition }
      derived_column: total_departures_from_state {
        sql: SUM(transition_count) OVER (PARTITION BY from_state) ;;
      }
    }
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(COALESCE(${from_state}, ''), '->', COALESCE(${to_state}, '')) ;;
  }

  dimension: from_state {
    label: "Origin Step State"
    description: "Origin clickstream page event_type from which the browsing transition starts."
    synonyms: ["from state", "origin event state", "source step"]
    type: string
    sql: ${TABLE}.from_state ;;
  }

  dimension: to_state {
    label: "Destination Step State"
    description: "Destination clickstream page event_type or 'SESSION_EXIT' following the origin step."
    synonyms: ["to state", "destination event state", "next step"]
    type: string
    sql: ${TABLE}.to_state ;;
  }

  dimension: _transition_count {
    hidden: yes
    type: number
    sql: ${TABLE}.transition_count ;;
  }

  dimension: _total_departures_from_state {
    hidden: yes
    type: number
    sql: ${TABLE}.total_departures_from_state ;;
  }

  dimension: _avg_dwell_sec {
    hidden: yes
    type: number
    sql: ${TABLE}.avg_dwell_sec ;;
  }

  measure: transition_count {
    label: "Step Transitions"
    description: "Total count of clickstream step-to-step transitions between the origin and destination states."
    synonyms: ["transition count", "step transitions"]
    type: sum
    sql: ${_transition_count} ;;
  }

  measure: total_departures_from_state {
    label: "Total Departures from Origin State"
    description: "Total clickstream departures originating from the source page event_type across all destination states."
    synonyms: ["total departures from state", "origin state departures"]
    tags: ["non_additive"]
    type: max
    sql: ${_total_departures_from_state} ;;
  }

  measure: transition_probability {
    label: "Step-to-Step Transition Probability"
    description: "Clickstream Step-to-Step Transition Matrix probability that a shopper moves from the origin page type to the destination step or exits the site."
    synonyms: ["transition probability", "transition probability pct", "step transition share"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${transition_count} / NULLIF(${total_departures_from_state}, 0) ;;
    value_format_name: percent_2
  }

  measure: avg_seconds_before_transition {
    label: "Average Seconds Before Transition"
    description: "Average seconds spent on the origin step before transitioning to the destination step (0 for SESSION_EXIT)."
    synonyms: ["avg seconds before transition", "mean step dwell seconds"]
    tags: ["non_additive"]
    type: average
    sql: ${_avg_dwell_sec} ;;
    value_format_name: decimal_1
  }
}
