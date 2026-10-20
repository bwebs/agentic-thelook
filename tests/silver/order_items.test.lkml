include: "../../silver/explores/order_items.explore.lkml"

test: order_items_fact_metrics_at_fixed_date {
  explore_source: order_items {
    column: total_revenue { field: order_items.total_revenue }
    column: order_item_count { field: order_items.count }
    column: total_line_items_sold { field: order_items.total_line_items_sold }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
  }
  assert: total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 3662.74 ;;
  }
  assert: order_item_count_matches {
    expression: ${order_items.count} = 57 ;;
  }
  assert: total_line_items_sold_matches {
    expression: ${order_items.total_line_items_sold} = 57 ;;
  }
}
