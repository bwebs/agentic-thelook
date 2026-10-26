include: "../../silver/explores/order_items.explore.lkml"

test: order_items_2024_01_01_socks_obsession_metrics {
  explore_source: order_items {
    column: sock_units_sold { field: order_items_products_fields.sock_units_sold }
    column: total_units_sold { field: order_items.count }
    column: sock_unit_share { field: order_items_products_fields.sock_unit_share }
    column: total_sock_revenue { field: order_items_products_fields.total_sock_revenue }
    column: sock_revenue_share { field: order_items_products_fields.sock_revenue_share }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
  }
  assert: sock_units_sold_matches {
    expression: ${order_items_products_fields.sock_units_sold} = 6 ;;
  }
  assert: total_units_sold_matches {
    expression: ${order_items.count} = 80 ;;
  }
  assert: sock_unit_share_matches {
    expression: round(${order_items_products_fields.sock_unit_share}, 4) = 0.075 ;;
  }
  assert: total_sock_revenue_matches {
    expression: round(${order_items_products_fields.total_sock_revenue}, 2) = 73.39 ;;
  }
  assert: sock_revenue_share_matches {
    expression: round(${order_items_products_fields.sock_revenue_share}, 4) = 0.0161 ;;
  }
}

test: order_items_2024_01_01_orders_join_metrics {
  explore_source: order_items {
    column: order_item_count { field: order_items.count }
    column: order_count { field: orders.count }
    column: ever_returned_items { field: order_items.ever_returned_items }
    column: refunded_revenue { field: order_items.refunded_revenue }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
    filters: {
      field: orders.order_id
      value: "NOT NULL"
    }
    filters: {
      field: products.id
      value: "NOT NULL"
    }
  }
  assert: order_item_count_matches {
    expression: ${order_items.count} = 80 ;;
  }
  assert: order_count_symmetric_matches {
    expression: ${orders.count} = 71 ;;
  }
  assert: ever_returned_items_matches {
    expression: ${order_items.ever_returned_items} = 12 ;;
  }
  assert: refunded_revenue_matches {
    expression: round(${order_items.refunded_revenue}, 2) = 563.41 ;;
  }
}

test: order_items_2024_01_01_thermal_chill_metrics {
  explore_source: order_items {
    column: order_item_count { field: order_items.count }
    column: total_revenue { field: order_items.total_revenue }
    column: total_warm_clothing_revenue { field: order_items_products_fields.total_warm_clothing_revenue }
    column: warm_clothing_revenue_share { field: order_items_products_fields.warm_clothing_revenue_share }
    column: avg_abs_latitude { field: users.avg_abs_latitude }
    column: avg_activity_weighted_abs_latitude { field: order_items_users_fields.avg_activity_weighted_abs_latitude }
    column: latitude_price_correlation { field: order_items_users_fields.latitude_price_correlation }
    column: age_price_correlation { field: order_items_users_fields.age_price_correlation }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
    filters: {
      field: users.id
      value: "NOT NULL"
    }
    filters: {
      field: products.id
      value: "NOT NULL"
    }
  }
  assert: order_item_count_matches {
    expression: ${order_items.count} = 80 ;;
  }
  assert: total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 4564.89 ;;
  }
  assert: total_warm_clothing_revenue_matches {
    expression: round(${order_items_products_fields.total_warm_clothing_revenue}, 2) = 1060.61 ;;
  }
  assert: warm_clothing_revenue_share_matches {
    expression: round(${order_items_products_fields.warm_clothing_revenue_share}, 4) = 0.2323 ;;
  }
  assert: avg_abs_latitude_symmetric_matches {
    expression: round(${users.avg_abs_latitude}, 2) = 32.92 ;;
  }
  assert: avg_activity_weighted_abs_latitude_matches {
    expression: round(${order_items_users_fields.avg_activity_weighted_abs_latitude}, 2) = 32.44 ;;
  }
  assert: latitude_price_correlation_matches {
    expression: round(${order_items_users_fields.latitude_price_correlation}, 4) = -0.1648 ;;
  }
  assert: age_price_correlation_matches {
    expression: round(${order_items_users_fields.age_price_correlation}, 4) = 0.1331 ;;
  }
}

test: order_items_2024_01_01_cross_shopping_metrics {
  explore_source: order_items {
    column: cross_department_gift_items { field: order_items_products_users_fields.cross_department_gift_items }
    column: order_item_count { field: order_items.count }
    column: total_revenue { field: order_items.total_revenue }
    column: avg_item_price { field: order_items.avg_item_price }
    column: cross_shopping_rate { field: order_items_products_users_fields.cross_shopping_rate }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
    filters: {
      field: users.id
      value: "NOT NULL"
    }
    filters: {
      field: orders.order_id
      value: "NOT NULL"
    }
    filters: {
      field: products.id
      value: "NOT NULL"
    }
  }
  assert: cross_department_gift_items_matches {
    expression: ${order_items_products_users_fields.cross_department_gift_items} = 0 ;;
  }
  assert: order_item_count_matches {
    expression: ${order_items.count} = 80 ;;
  }
  assert: total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 4564.89 ;;
  }
  assert: avg_item_price_matches {
    expression: round(${order_items.avg_item_price}, 2) = 57.06 ;;
  }
  assert: cross_shopping_rate_matches {
    expression: round(${order_items_products_users_fields.cross_shopping_rate}, 4) = 0 ;;
  }
}


test: order_items_2024_01_seasonal_category_metrics {
  explore_source: order_items {
    column: activewear_units { field: order_items_products_fields.activewear_units }
    column: swimwear_units { field: order_items_products_fields.swimwear_units }
    column: winter_cozy_units { field: order_items_products_fields.winter_cozy_units }
    column: total_revenue { field: order_items.total_revenue }
    filters: {
      field: order_items.created_date
      value: "2024-01-01 to 2024-02-01"
    }
    filters: {
      field: products.id
      value: "NOT NULL"
    }
  }
  assert: activewear_units_matches {
    expression: ${order_items_products_fields.activewear_units} = 107 ;;
  }
  assert: swimwear_units_matches {
    expression: ${order_items_products_fields.swimwear_units} = 118 ;;
  }
  assert: winter_cozy_units_matches {
    expression: ${order_items_products_fields.winter_cozy_units} = 238 ;;
  }
  assert: total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 123613.15 ;;
  }
}

test: order_items_2024_01_01_dc_1_join_metrics {
  explore_source: order_items {
    column: item_count { field: order_items.count }
    column: total_revenue { field: order_items.total_revenue }
    filters: [
      order_items.created_date: "2024-01-01",
      distribution_centers.id: "1"
    ]
  }
  assert: dc_1_item_count_matches {
    expression: ${order_items.count} = 4 ;;
  }
  assert: dc_1_total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 194.97 ;;
  }
}

test: order_items_2024_01_complete_gross_profit {
  explore_source: order_items {
    column: total_gross_profit { field: inventory_items_order_items_fields.total_gross_profit }
    column: gross_margin_ratio { field: inventory_items_order_items_fields.gross_margin_ratio }
    filters: {
      field: order_items.created_date
      value: "2024-01"
    }
    filters: {
      field: order_items.status
      value: "Complete"
    }
  }
  assert: total_gross_profit_matches {
    expression: round(${inventory_items_order_items_fields.total_gross_profit}, 2) = 16633.21 ;;
  }
  assert: gross_margin_ratio_matches {
    expression: round(${inventory_items_order_items_fields.gross_margin_ratio}, 4) = 0.5221 ;;
  }
}

test: order_items_department_units_2024_01_01 {
  explore_source: order_items {
    column: mens_units { field: order_items_products_fields.mens_units }
    column: womens_units { field: order_items_products_fields.womens_units }
    column: count { field: order_items.count }
    filters: [order_items.created_date: "2024-01-01"]
  }
  assert: mens_units_matches {
    expression: ${order_items_products_fields.mens_units} = 25 ;;
  }
  assert: womens_units_matches {
    expression: ${order_items_products_fields.womens_units} = 30 ;;
  }
  assert: department_units_partition_total {
    expression: ${order_items_products_fields.mens_units} + ${order_items_products_fields.womens_units} = ${order_items.count} ;;
  }
}

test: order_items_2024_01_01_geospatial_haul_metrics {
  explore_source: order_items {
    column: geospatial_haul_classification { field: distribution_centers_order_items_users_fields.geospatial_haul_classification }
    column: count { field: order_items.count }
    column: avg_shipment_distance_km { field: distribution_centers_order_items_users_fields.avg_shipment_distance_km }
    column: avg_lat_degrees_crossed { field: distribution_centers_order_items_users_fields.avg_lat_degrees_crossed }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
    filters: {
      field: inventory_items.id
      value: "NOT NULL"
    }
    filters: {
      field: distribution_centers.id
      value: "NOT NULL"
    }
    filters: {
      field: users.id
      value: "NOT NULL"
    }
    sorts: [distribution_centers_order_items_users_fields.geospatial_haul_classification: asc]
  }
  assert: local_regional_hop_row_matches {
    expression: index(${distribution_centers_order_items_users_fields.geospatial_haul_classification}, 1) = "Local Regional Hop (<5 deg Lat & <10 deg Lon)" ;;
  }
  assert: local_regional_hop_count_matches {
    expression: index(${order_items.count}, 1) = 2 ;;
  }
  assert: local_regional_hop_distance_matches {
    expression: round(index(${distribution_centers_order_items_users_fields.avg_shipment_distance_km}, 1), 1) = 761.9 ;;
  }
  assert: local_regional_hop_lat_span_matches {
    expression: round(index(${distribution_centers_order_items_users_fields.avg_lat_degrees_crossed}, 1), 2) = 2.40 ;;
  }
  assert: trans_oceanic_expedition_count_matches {
    expression: index(${order_items.count}, 3) = 45 ;;
  }
}

test: order_items_2024_01_01_trade_corridor_metrics {
  explore_source: order_items {
    column: trade_corridor_regime { field: distribution_centers_order_items_users_fields.trade_corridor_regime }
    column: count { field: order_items.count }
    column: avg_shipment_distance_km { field: distribution_centers_order_items_users_fields.avg_shipment_distance_km }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
    filters: {
      field: inventory_items.id
      value: "NOT NULL"
    }
    filters: {
      field: distribution_centers.id
      value: "NOT NULL"
    }
    filters: {
      field: users.id
      value: "NOT NULL"
    }
    sorts: [distribution_centers_order_items_users_fields.trade_corridor_regime: asc]
  }
  assert: domestic_short_haul_label_matches {
    expression: index(${distribution_centers_order_items_users_fields.trade_corridor_regime}, 1) = "Domestic Short-Haul Trucking Corridor (<800 km US)" ;;
  }
  assert: domestic_short_haul_count_matches {
    expression: index(${order_items.count}, 1) = 2 ;;
  }
  assert: transpacific_corridor_count_matches {
    expression: index(${order_items.count}, 4) = 22 ;;
  }
  assert: transpacific_corridor_distance_matches {
    expression: round(index(${distribution_centers_order_items_users_fields.avg_shipment_distance_km}, 4), 1) = 11894.4 ;;
  }
}
