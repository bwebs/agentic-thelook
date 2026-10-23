include: "../../bronze/explores/orders.explore.lkml"

test: orders_refinement_metrics {
  explore_source: orders {
    column: avg_items_per_order { field: orders.avg_items_per_order }
    column: max_items_per_order { field: orders.max_items_per_order }
    column: stddev_items_per_order { field: orders.stddev_items_per_order }
    column: order_count { field: orders.count }
    filters: {
      field: orders.created_date
      value: "2024-01-01"
    }
  }
  assert: avg_items_per_order_matches {
    expression: round(${orders.avg_items_per_order}, 2) = 1.31 ;;
  }
  assert: max_items_per_order_matches {
    expression: ${orders.max_items_per_order} = 3 ;;
  }
  assert: stddev_items_per_order_matches {
    expression: round(${orders.stddev_items_per_order}, 2) = 0.58 ;;
  }
  assert: order_count_matches {
    expression: ${orders.count} = 36 ;;
  }
}
