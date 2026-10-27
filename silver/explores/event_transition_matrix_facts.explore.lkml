include: "/silver/event_transition_matrix_facts.view.lkml"

explore: event_transition_matrix_facts {
  label: "Clickstream Step Transition Matrix"
  view_name: event_transition_matrix_facts
  hidden: no

  query: clickstream_step_transition_matrix {
    description: "Clickstream Step-to-Step Transition Matrix showing transition count, total departures from origin state, transition probability, and average dwell seconds by origin and destination state."
    dimensions: [
      event_transition_matrix_facts.from_state,
      event_transition_matrix_facts.to_state
    ]
    measures: [
      event_transition_matrix_facts.transition_count,
      event_transition_matrix_facts.total_departures_from_state,
      event_transition_matrix_facts.transition_probability,
      event_transition_matrix_facts.avg_seconds_before_transition
    ]
    sorts: [
      event_transition_matrix_facts.from_state: asc,
      event_transition_matrix_facts.transition_probability: desc
    ]
  }
}
