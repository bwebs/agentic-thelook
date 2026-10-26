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

test: events_2024_01_01_marathon_tier_metrics {
  explore_source: events {
    column: session_marathon_tier { field: browsing_session_facts.session_marathon_tier }
    column: sessions_count { field: browsing_session_facts.count }
    column: converted_sessions { field: browsing_session_facts.converted_sessions }
    column: session_conversion_rate { field: browsing_session_facts.session_conversion_rate }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
    sorts: [browsing_session_facts.session_marathon_tier: asc]
  }
  assert: bounce_and_peek_tiers_match {
    expression: index(${browsing_session_facts.session_marathon_tier}, 1) = "One-Hit Bounce (1 Event)" AND index(${browsing_session_facts.count}, 1) = 46 AND index(${browsing_session_facts.converted_sessions}, 1) = 0 AND round(index(${browsing_session_facts.session_conversion_rate}, 1), 4) = 0 AND index(${browsing_session_facts.session_marathon_tier}, 2) = "Casual Window Peek (2-4 Events)" AND index(${browsing_session_facts.count}, 2) = 129 ;;
  }
  assert: audit_and_marathon_tiers_match {
    expression: index(${browsing_session_facts.session_marathon_tier}, 3) = "Serious Closet Audit (5-9 Events)" AND index(${browsing_session_facts.count}, 3) = 71 AND index(${browsing_session_facts.converted_sessions}, 3) = 71 AND round(index(${browsing_session_facts.session_conversion_rate}, 3), 4) = 1 AND index(${browsing_session_facts.session_marathon_tier}, 4) = "Doom-Scroll Fashion Marathon (10+ Events)" AND index(${browsing_session_facts.count}, 4) = 23 AND index(${browsing_session_facts.converted_sessions}, 4) = 23 AND round(index(${browsing_session_facts.session_conversion_rate}, 4), 4) = 1 ;;
  }
}

test: events_2024_01_01_funnel_archetype_invariants {
  explore_source: events {
    column: total_sessions { field: browsing_session_facts.count }
    column: silent_cart_abandon_sessions { field: browsing_session_facts.silent_cart_abandon_sessions }
    column: explicit_cancel_sessions { field: browsing_session_facts.explicit_cancel_sessions }
    column: converted_sessions { field: browsing_session_facts.converted_sessions }
    column: avg_events_per_session { field: browsing_session_facts.avg_events_per_session }
    filters: [events.created_date: "2024-01-01"]
  }
  assert: funnel_session_invariants_hold {
    expression: ${browsing_session_facts.silent_cart_abandon_sessions} > 0
      AND ${browsing_session_facts.explicit_cancel_sessions} > 0
      AND ${browsing_session_facts.count} >= ${browsing_session_facts.converted_sessions} + ${browsing_session_facts.silent_cart_abandon_sessions}
      AND ${browsing_session_facts.avg_events_per_session} >= 1 ;;
  }
}
