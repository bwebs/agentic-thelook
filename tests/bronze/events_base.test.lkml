include: "../../bronze/explores/events_base.explore.lkml"

test: events_base_refinement_metrics {
  explore_source: events_base {
    column: count { field: events.count }
    column: unique_chaotic_sessions { field: events.unique_chaotic_sessions }
    column: distinct_clicking_humans { field: events.distinct_clicking_humans }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
  }
  assert: count_matches {
    expression: ${events.count} = 774 ;;
  }
  assert: unique_chaotic_sessions_matches {
    expression: ${events.unique_chaotic_sessions} = 251 ;;
  }
  assert: distinct_clicking_humans_matches {
    expression: ${events.distinct_clicking_humans} = 63 ;;
  }
}
