include: "../../silver/explores/order_items.explore.lkml"

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

test: order_items_2024_01_01_active_buyers_metrics {
  explore_source: order_items {
    column: distinct_users { field: order_items.distinct_users }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
  }
  assert: distinct_users_matches {
    expression: ${order_items.distinct_users} = 71 ;;
  }
}

test: order_items_2024_01_01_boomerang_return_metrics {
  explore_source: order_items {
    column: ever_returned_items { field: order_items.ever_returned_items }
    column: ever_return_rate { field: order_items.ever_return_rate }
    column: refunded_revenue { field: order_items.refunded_revenue }
    column: returned_items { field: order_items.returned_items }
    column: return_rate { field: order_items.return_rate }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
  }
  assert: ever_returned_items_matches {
    expression: ${order_items.ever_returned_items} = 12 ;;
  }
  assert: ever_return_rate_matches {
    expression: round(${order_items.ever_return_rate}, 4) = 0.15 ;;
  }
  assert: refunded_revenue_matches {
    expression: round(${order_items.refunded_revenue}, 2) = 563.41 ;;
  }
  assert: returned_items_matches {
    expression: ${order_items.returned_items} = 12 ;;
  }
  assert: return_rate_matches {
    expression: round(${order_items.return_rate}, 4) = 0.15 ;;
  }
}

test: order_items_2024_01_01_high_roller_single_item_metrics {
  explore_source: order_items {
    column: order_item_count { field: order_items.count }
    column: total_revenue { field: order_items.total_revenue }
    column: avg_item_price { field: order_items.avg_item_price }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
    filters: {
      field: order_items.is_high_roller_single_item
      value: "yes"
    }
  }
  assert: high_roller_item_count_matches {
    expression: ${order_items.count} = 11 ;;
  }
  assert: high_roller_total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 2195.79 ;;
  }
  assert: high_roller_avg_item_price_matches {
    expression: round(${order_items.avg_item_price}, 2) = 199.62 ;;
  }
}

test: order_items_2024_01_fulfillment_speed_tier {
  explore_source: order_items {
    column: fulfillment_speed_tier { field: order_items.fulfillment_speed_tier }
    column: count { field: order_items.count }
    filters: [order_items.delivered_date: "2024-01"]
    sorts: [order_items.fulfillment_speed_tier: asc]
  }
  assert: fulfillment_speed_tier_counts_match {
    expression: index(${order_items.fulfillment_speed_tier}, 1) = "Supersonic Drone Speed (<24h)"
      AND index(${order_items.count}, 1) = 118
      AND index(${order_items.fulfillment_speed_tier}, 2) = "Prime-ish Express (24-72h)"
      AND index(${order_items.count}, 2) = 189
      AND index(${order_items.fulfillment_speed_tier}, 3) = "Standard Pony Express (72-120h)"
      AND index(${order_items.count}, 3) = 248
      AND index(${order_items.fulfillment_speed_tier}, 4) = "Lost-at-Sea Snail Mail (120h+)"
      AND index(${order_items.count}, 4) = 146 ;;
  }
}

test: order_items_2024_seasonal_vintage_metrics {
  explore_source: order_items {
    column: retail_seasonal_vintage { field: order_items.retail_seasonal_vintage }
    column: created_month_num { field: order_items.created_month_num }
    column: count { field: order_items.count }
    filters: {
      field: order_items.created_date
      value: "2024-01-15, 2024-04-15, 2024-06-15, 2024-09-15, 2024-11-15"
    }
    sorts: [order_items.retail_seasonal_vintage: asc]
  }
  assert: q4_holiday_vintage_matches {
    expression: index(${order_items.retail_seasonal_vintage}, 1) = "Q4 Cyber-Holiday Frenzy (Nov-Dec)" AND index(${order_items.created_month_num}, 1) = 11 AND index(${order_items.count}, 1) = 88 ;;
  }
  assert: fall_layering_vintage_matches {
    expression: index(${order_items.retail_seasonal_vintage}, 2) = "Back-to-School & Fall Layering (Aug-Oct)" AND index(${order_items.created_month_num}, 2) = 9 AND index(${order_items.count}, 2) = 83 ;;
  }
  assert: spring_reboot_vintage_matches {
    expression: index(${order_items.retail_seasonal_vintage}, 3) = "Spring Wardrobe Reboot (Mar-May)" AND index(${order_items.created_month_num}, 3) = 4 AND index(${order_items.count}, 3) = 66 ;;
  }
  assert: mid_summer_vintage_matches {
    expression: index(${order_items.retail_seasonal_vintage}, 4) = "Mid-Summer Fiesta (Jun-Jul)" AND index(${order_items.created_month_num}, 4) = 6 AND index(${order_items.count}, 4) = 92 ;;
  }
  assert: new_year_rush_vintage_matches {
    expression: index(${order_items.retail_seasonal_vintage}, 5) = "New-Year Resolution Rush (Jan-Feb)" AND index(${order_items.created_month_num}, 5) = 1 AND index(${order_items.count}, 5) = 60 ;;
  }
}

test: order_items_2024_2025_boundary_era_and_reversed_metrics {
  explore_source: order_items {
    column: is_reversed { field: order_items.is_reversed }
    column: completed_items { field: order_items.completed_items }
    column: recent_era_revenue { field: order_items.recent_era_revenue }
    column: recent_era_revenue_share { field: order_items.recent_era_revenue_share }
    filters: [
      order_items.created_date: "2024-12-31,2025-01-01",
      order_items.status: "Complete,Returned,Cancelled"
    ]
    sorts: [order_items.is_reversed: asc]
  }
  assert: is_reversed_partition_matches {
    expression: NOT index(${order_items.is_reversed}, 1)
      AND index(${order_items.is_reversed}, 2)
      AND index(${order_items.completed_items}, 1) = 45
      AND index(${order_items.completed_items}, 2) = 0 ;;
  }
  assert: recent_era_revenue_matches {
    expression: round(index(${order_items.recent_era_revenue}, 1), 2) = 1183.18
      AND round(index(${order_items.recent_era_revenue}, 2), 2) = 853.92 ;;
  }
  assert: recent_era_revenue_share_matches {
    expression: round(index(${order_items.recent_era_revenue_share}, 1), 4) = 0.389
      AND round(index(${order_items.recent_era_revenue_share}, 2), 4) = 0.4279 ;;
  }
}

test: order_items_2024_01_01_spend_per_buyer {
  explore_source: order_items {
    column: total_revenue { field: order_items.total_revenue }
    column: distinct_users { field: order_items.distinct_users }
    column: spend_per_buyer { field: order_items.spend_per_buyer }
    filters: [
      order_items.created_date: "2024-01-01",
      order_items.status: "Complete"
    ]
  }
  assert: spend_per_buyer_matches {
    expression: round(${order_items.spend_per_buyer}, 2) = 70.20 ;;
  }
}
