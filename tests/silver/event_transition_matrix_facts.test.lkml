include: "../../silver/explores/event_transition_matrix_facts.explore.lkml"

test: event_transition_matrix_probability_invariants {
  explore_source: event_transition_matrix_facts {
    column: from_state { field: event_transition_matrix_facts.from_state }
    column: to_state { field: event_transition_matrix_facts.to_state }
    column: transition_count { field: event_transition_matrix_facts.transition_count }
    column: total_departures_from_state { field: event_transition_matrix_facts.total_departures_from_state }
    column: transition_probability { field: event_transition_matrix_facts.transition_probability }
    column: avg_seconds_before_transition { field: event_transition_matrix_facts.avg_seconds_before_transition }
    filters: [event_transition_matrix_facts.from_state: "cart"]
  }
  assert: transition_probability_matches_ratio {
    expression: ${event_transition_matrix_facts.transition_probability} > 0 AND ${event_transition_matrix_facts.transition_probability} <= 1 AND round(${event_transition_matrix_facts.transition_probability}, 6) = round(${event_transition_matrix_facts.transition_count} / ${event_transition_matrix_facts.total_departures_from_state}, 6) ;;
  }
  assert: dwell_seconds_non_negative {
    expression: ${event_transition_matrix_facts.avg_seconds_before_transition} >= 0 ;;
  }
}
