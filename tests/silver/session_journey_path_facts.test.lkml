include: "../../silver/explores/session_journey_path_facts.explore.lkml"

test: session_journey_path_share_invariants {
  explore_source: session_journey_path_facts {
    column: is_converted_to_purchase { field: session_journey_path_facts.is_converted_to_purchase }
    column: session_frequency { field: session_journey_path_facts.session_frequency }
    column: share_of_all_sessions { field: session_journey_path_facts.share_of_all_sessions }
    filters: [session_journey_path_facts.is_converted_to_purchase: "yes"]
  }
  assert: converted_journey_share_bounds {
    expression: ${session_journey_path_facts.session_frequency} > 0 AND ${session_journey_path_facts.share_of_all_sessions} > 0 AND ${session_journey_path_facts.share_of_all_sessions} < 1 ;;
  }
}
