include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/explores/users_base.explore.lkml"
include: "/silver/order_items_users_fields.view.lkml"
include: "/silver/orders_users_fields.view.lkml"

explore: users {
  extends: [users_base]
  label: "Users"
  view_name: users
  hidden: no

  join: orders {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${orders.user_id} ;;
  }

  join: orders_users_fields {
    view_label: "Users"
    sql: ;;
    relationship: one_to_one
  }

  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: order_items_users_fields {
    view_label: "Users"
    sql: ;;
    relationship: one_to_one
  }

  query: country_per_capita_fashion_spend {
    description: "Country Per-Capita Fashion Spend measures total revenue, average shopper age, and average spend per registered customer across every country we serve."
    dimensions: [users.country]
    measures: [
      users.count,
      users.avg_customer_age,
      order_items.count,
      order_items.total_revenue,
      order_items_users_fields.revenue_per_registered_user
    ]
    sorts: [order_items.total_revenue: desc]
  }

  query: channel_revenue_by_country_and_traffic_source {
    description: "Top 20 country and marketing traffic source combinations ranked by total channel revenue from purchasing customers."
    dimensions: [users.country, users.traffic_source]
    measures: [order_items.total_revenue]
    filters: [order_items.id: "NOT NULL"]
    sorts: [order_items.total_revenue: desc]
    limit: 20
  }

  query: ghost_account_overview {
    description: "Overall registered customers, buying users, dormant ghost accounts, and Ghost Account Window-Shopper Rate."
    measures: [
      users.count,
      orders.distinct_users,
      orders_users_fields.ghost_users,
      orders_users_fields.ghost_account_rate
    ]
  }

  query: ghost_account_rate_by_traffic_source {
    description: "Ghost Account Window-Shopper Rate and dormant signup pool broken down by customer acquisition traffic source."
    dimensions: [users.traffic_source]
    measures: [
      users.count,
      orders_users_fields.ghost_users,
      orders_users_fields.ghost_account_rate
    ]
    sorts: [orders_users_fields.ghost_account_rate: desc]
  }
}
