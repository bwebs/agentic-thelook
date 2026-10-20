test: order_items_base_refinement_metrics {
  explore_source: order_items_base {
    column: total_revenue { field: order_items.total_revenue }
    column: order_item_count { field: order_items.count }
    filters: {
      field: order_items.created_date
      value: "2026-01-01"
    }
  }
  assert: total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 8622.57 ;;
  }
  assert: order_item_count_matches {
    expression: ${order_items.count} = 141 ;;
  }
}
