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

test: orders_2024_01_01_remorse_metrics {
  explore_source: orders {
    column: total_items { field: orders.total_items }
    column: cancelled_or_returned_orders { field: orders.cancelled_or_returned_orders }
    filters: {
      field: orders.created_date
      value: "2024-01-01"
    }
  }
  assert: total_items_matches {
    expression: ${orders.total_items} = 71 ;;
  }
  assert: cancelled_or_returned_orders_matches {
    expression: ${orders.cancelled_or_returned_orders} = 15 ;;
  }
}

test: orders_2024_01_01_distinct_users_metrics {
  explore_source: orders {
    column: distinct_users { field: orders.distinct_users }
    column: order_count { field: orders.count }
    filters: {
      field: orders.created_date
      value: "2024-01-01"
    }
  }
  assert: distinct_users_matches {
    expression: ${orders.distinct_users} = 51 ;;
  }
}

test: orders_2024_01_01_mega_basket_bulk_orders_metrics {
  explore_source: orders {
    column: order_count { field: orders.count }
    column: total_items { field: orders.total_items }
    column: avg_items_per_order { field: orders.avg_items_per_order }
    column: max_items_per_order { field: orders.max_items_per_order }
    filters: {
      field: orders.created_date
      value: "2024-01-01"
    }
    filters: {
      field: orders.is_mega_basket_bulk_order
      value: "yes"
    }
  }
  assert: mega_basket_order_count_matches {
    expression: ${orders.count} = 7 ;;
  }
  assert: mega_basket_total_items_matches {
    expression: ${orders.total_items} = 24 ;;
  }
  assert: mega_basket_avg_items_per_order_matches {
    expression: round(${orders.avg_items_per_order}, 3) = 3.429 ;;
  }
  assert: mega_basket_max_items_per_order_matches {
    expression: ${orders.max_items_per_order} = 4 ;;
  }
}
