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
