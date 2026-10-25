include: "../../bronze/explores/events.explore.lkml"

test: events_refinement_metrics {
  explore_source: events {
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

test: events_rage_quit_abandonment_metrics {
  explore_source: events {
    column: cart_events { field: events.cart_events }
    column: purchase_events { field: events.purchase_events }
    column: cancel_events { field: events.cancel_events }
    column: carts_per_purchase_ratio { field: events.carts_per_purchase_ratio }
    column: cancel_to_cart_ratio { field: events.cancel_to_cart_ratio }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
  }
  assert: cart_events_matches {
    expression: ${events.cart_events} = 191 ;;
  }
  assert: purchase_events_matches {
    expression: ${events.purchase_events} = 63 ;;
  }
  assert: cancel_events_matches {
    expression: ${events.cancel_events} = 44 ;;
  }
  assert: carts_per_purchase_ratio_matches {
    expression: round(${events.carts_per_purchase_ratio}, 2) = 3.03 ;;
  }
  assert: cancel_to_cart_ratio_matches {
    expression: round(${events.cancel_to_cart_ratio}, 4) = 0.2304 ;;
  }
}
