include: "../../silver/explores/events.explore.lkml"

test: events_2024_01_01_speed_runner_checkout_metrics {
  explore_source: events {
    column: min_checkout_duration_sec { field: event_session_facts.min_checkout_duration_sec }
    column: avg_checkout_duration_sec { field: event_session_facts.avg_checkout_duration_sec }
    column: max_checkout_duration_sec { field: event_session_facts.max_checkout_duration_sec }
    column: purchasing_sessions { field: event_session_facts.count }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
    filters: {
      field: event_session_facts.session_id
      value: "-NULL"
    }
  }
  assert: min_checkout_duration_sec_matches {
    expression: ${event_session_facts.min_checkout_duration_sec} = 35 ;;
  }
  assert: avg_checkout_duration_sec_matches {
    expression: round(${event_session_facts.avg_checkout_duration_sec}, 2) = 123270.09 ;;
  }
  assert: max_checkout_duration_sec_matches {
    expression: ${event_session_facts.max_checkout_duration_sec} = 346922 ;;
  }
  assert: purchasing_sessions_matches {
    expression: ${event_session_facts.count} = 105 ;;
  }
}

test: events_2024_01_01_session_structural_role {
  explore_source: events {
    column: session_structural_role { field: event_session_steps.session_structural_role }
    column: count { field: events.count }
    filters: [events.created_date: "2024-01-01"]
    sorts: [event_session_steps.session_structural_role: asc]
  }
  assert: session_structural_role_counts_match {
    expression: index(${event_session_steps.session_structural_role}, 1) = "Solo Single-Click Bounce Event"
      AND index(${events.count}, 1) = 46
      AND index(${event_session_steps.session_structural_role}, 2) = "Doorway Opener (Session First Touch)"
      AND index(${events.count}, 2) = 202
      AND index(${event_session_steps.session_structural_role}, 3) = "Middle-Funnel Meandering Step"
      AND index(${events.count}, 3) = 449
      AND index(${event_session_steps.session_structural_role}, 4) = "Curtain Closer (Session Last Touch)"
      AND index(${events.count}, 4) = 183 ;;
  }
}
