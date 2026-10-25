include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/bronze/explores/order_items_base.explore.lkml"
include: "/silver/order_items_products_fields.view.lkml"

explore: order_items {
  extends: [order_items_base]
  label: "Order Items"
  view_name: order_items
  hidden: no
  fields: [ALL_FIELDS*, -products.markup_greed_pct, -products.avg_markup_greed_pct]

  join: orders {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.product_id} = ${products.id} ;;
  }

  join: order_items_products_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  query: socks_and_hosiery_obsession_index {
    description: "Socks and Hosiery Obsession Index calculates what percentage of all units sold and total store revenue comes specifically from customers buying socks and hosiery across men's and women's lines."
    measures: [
      order_items_products_fields.sock_units_sold,
      order_items.count,
      order_items_products_fields.sock_unit_share,
      order_items_products_fields.total_sock_revenue,
      order_items_products_fields.sock_revenue_share
    ]
  }

  query: socks_and_hosiery_sales_by_category_and_department {
    description: "Units sold and gross revenue for Socks and Socks & Hosiery broken down by product category and department."
    dimensions: [products.category, products.department]
    measures: [
      order_items.count,
      order_items.total_revenue
    ]
    filters: [products.category: "Socks,Socks & Hosiery"]
    sorts: [order_items.total_revenue: desc]
  }

  query: brand_return_boomerang_leaderboard {
    description: "Brand Return Boomerang Rate leaderboard showing total items ordered, boomeranged items, boomerang return rate, and refunded dollars by brand for brands with at least 30 ordered items."
    dimensions: [products.brand]
    measures: [
      order_items.count,
      order_items.ever_returned_items,
      order_items.ever_return_rate,
      order_items.refunded_revenue
    ]
    filters: [
      orders.order_id: "NOT NULL",
      products.id: "NOT NULL",
      order_items.count: ">=30"
    ]
    sorts: [order_items.ever_return_rate: desc]
    limit: 20
  }

  query: category_return_rate_leaderboard {
    description: "Clothing categories ranked by customer item return rate, showing items ordered, items returned, and return rate."
    dimensions: [products.category]
    measures: [
      order_items.count,
      order_items.returned_items,
      order_items.return_rate
    ]
    filters: [products.id: "NOT NULL"]
    sorts: [order_items.return_rate: desc]
    limit: 15
  }
}
