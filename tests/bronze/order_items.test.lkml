include: "../../bronze/explores/order_items.explore.lkml"

test: order_items_refinement_metrics {
  explore_source: order_items {
    column: total_revenue { field: order_items.total_revenue }
    column: order_item_count { field: order_items.count }
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
}

test: order_items_package_procrastination_metrics {
  explore_source: order_items {
    column: avg_warehouse_procrastination_hours { field: order_items.avg_warehouse_procrastination_hours }
    column: avg_truck_transit_hours { field: order_items.avg_truck_transit_hours }
    column: avg_total_doorstep_wait_hours { field: order_items.avg_total_doorstep_wait_hours }
    column: avg_hours_to_ship { field: order_items.avg_hours_to_ship }
    column: avg_hours_to_deliver { field: order_items.avg_hours_to_deliver }
    filters: {
      field: order_items.delivered_date
      value: "2024-01-01"
    }
    filters: {
      field: order_items.is_shipped
      value: "yes"
    }
    filters: {
      field: order_items.is_delivered
      value: "yes"
    }
  }
  assert: avg_warehouse_procrastination_hours_matches {
    expression: round(${order_items.avg_warehouse_procrastination_hours}, 2) = 2.81 ;;
  }
  assert: avg_truck_transit_hours_matches {
    expression: round(${order_items.avg_truck_transit_hours}, 2) = 55.88 ;;
  }
  assert: avg_total_doorstep_wait_hours_matches {
    expression: round(${order_items.avg_total_doorstep_wait_hours}, 2) = 58.88 ;;
  }
  assert: avg_hours_to_ship_matches {
    expression: round(${order_items.avg_hours_to_ship}, 2) = 2.88 ;;
  }
  assert: avg_hours_to_deliver_matches {
    expression: round(${order_items.avg_hours_to_deliver}, 2) = 56.42 ;;
  }
}

test: order_items_weekend_warrior_metrics {
  explore_source: order_items {
    column: avg_item_price { field: order_items.avg_item_price }
    column: distinct_orders { field: order_items.distinct_orders }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
  }
  assert: avg_item_price_matches {
    expression: round(${order_items.avg_item_price}, 2) = 56.71 ;;
  }
  assert: distinct_orders_matches {
    expression: ${order_items.distinct_orders} = 59 ;;
  }
}

test: order_items_midnight_owl_metrics {
  explore_source: order_items {
    column: late_night_revenue { field: order_items.late_night_revenue }
    column: late_night_revenue_share { field: order_items.late_night_revenue_share }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
  }
  assert: late_night_revenue_matches {
    expression: round(${order_items.late_night_revenue}, 2) = 1238.69 ;;
  }
  assert: late_night_revenue_share_matches {
    expression: round(${order_items.late_night_revenue_share}, 4) = 0.3467 ;;
  }
}
