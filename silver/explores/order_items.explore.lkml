include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/explores/order_items_base.explore.lkml"
include: "/silver/order_items_products_fields.view.lkml"
include: "/silver/order_items_products_users_fields.view.lkml"
include: "/silver/order_items_users_fields.view.lkml"

explore: order_items {
  extends: [order_items_base]
  label: "Order Items"
  view_name: order_items
  hidden: no
  fields: [
    ALL_FIELDS*,
    -products.markup_greed_pct,
    -products.avg_markup_greed_pct,
    -order_items_users_fields.revenue_per_registered_user
  ]

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

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: order_items_products_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: order_items_products_users_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: order_items_users_fields {
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

  query: warm_clothing_spend_by_thermal_zone {
    description: "Hemisphere and Latitude Fashion Chill Factor compares item volume, cozy warm clothing spend, total spend, and warm clothing spend share across customer latitude thermal zones."
    dimensions: [users.thermal_zone]
    measures: [
      order_items.count,
      order_items_products_fields.total_warm_clothing_revenue,
      order_items.total_revenue,
      order_items_products_fields.warm_clothing_revenue_share
    ]
    filters: [
      users.id: "NOT NULL",
      products.id: "NOT NULL"
    ]
    sorts: [users.thermal_zone: asc]
  }

  query: latitude_and_age_price_correlations {
    description: "Pearson correlations between customer absolute latitude or age and ordered item sale price, alongside average absolute customer latitude."
    measures: [
      order_items_users_fields.latitude_price_correlation,
      order_items_users_fields.age_price_correlation,
      users.avg_abs_latitude
    ]
    filters: [users.id: "NOT NULL"]
  }

  query: spend_by_shopper_gender_and_department {
    description: "Items bought, total spend, and average item price broken down by shopper gender and product department."
    dimensions: [users.gender, products.department]
    measures: [
      order_items.count,
      order_items.total_revenue,
      order_items.avg_item_price
    ]
    filters: [
      users.id: "NOT NULL",
      products.id: "NOT NULL"
    ]
    sorts: [
      users.gender: asc,
      products.department: asc
    ]
  }

  query: gender_cross_shopping_index {
    description: "Gender-Bending Wardrobe Cross-Shopping Index tracking cross-department gift items, total items sold, and cross-department purchasing rate across male and female shoppers."
    measures: [
      order_items_products_users_fields.cross_department_gift_items,
      order_items.count,
      order_items_products_users_fields.cross_shopping_rate
    ]
    filters: [
      users.id: "NOT NULL",
      orders.order_id: "NOT NULL",
      products.id: "NOT NULL"
    ]
  }

  query: high_roller_single_items {
    description: "High-Roller Single Item identifies any individual order item sold for a hundred dollars or more. Merchandising and fulfillment teams use this label to spot premium-ticket purchases that qualify for upgraded packaging and VIP post-purchase follow-up."
    dimensions: [
      order_items.id,
      order_items.order_id,
      order_items.user_id,
      order_items.product_id,
      order_items.status,
      order_items.sale_price
    ]
    filters: [order_items.is_high_roller_single_item: "yes"]
    sorts: [order_items.sale_price: desc]
    limit: 25
  }

  query: fulfillment_speed_tiers {
    description: "Order item volume and average item sale price across Flash-Flood versus Snail-Mail Fulfillment Tiers."
    dimensions: [order_items.fulfillment_speed_tier]
    measures: [
      order_items.count,
      order_items.avg_item_price
    ]
    sorts: [order_items.fulfillment_speed_tier: asc]
  }

  query: longest_doorstep_wait_items {
    description: "Top 15 delivered order items with the longest total doorstep wait time in hours, showing warehouse processing hours, carrier transit hours, and total hours."
    dimensions: [
      order_items.id,
      order_items.order_id,
      order_items.status,
      order_items.hours_to_ship,
      order_items.hours_to_deliver,
      order_items.hours_total_doorstep_wait
    ]
    filters: [order_items.is_delivered: "yes"]
    sorts: [order_items.hours_total_doorstep_wait: desc]
    limit: 15
  }
}
