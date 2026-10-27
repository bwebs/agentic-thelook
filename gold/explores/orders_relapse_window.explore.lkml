include: "/silver/explores/orders.explore.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/gold/orders_relapse_window.view.lkml"

explore: orders_relapse_window {
  extends: [orders]
  label: "Orders (30-Day Rapid Relapse Window)"
  view_name: orders
  hidden: no
  tags: ["gold"]

  join: relapse_30d_orders {
    from: orders
    view_label: "30-Day Follow-Up Orders"
    type: left_outer
    relationship: one_to_many
    sql_on: ${orders.user_id} = ${relapse_30d_orders.user_id}
      AND ${relapse_30d_orders.created_raw} > ${orders.created_raw}
      AND ${relapse_30d_orders.created_raw} <= TIMESTAMP_ADD(${orders.created_raw}, INTERVAL 30 DAY) ;;
  }

  join: orders_relapse_window {
    view_label: "Orders"
    sql: ;;
    relationship: one_to_one
  }

  query: rapid_30d_order_relapse_summary {
    description: "Summary of anchor orders triggering a 30-day follow-up order, rapid-relapse binge shoppers, and average cooldown days within the 30-day relapse window."
    measures: [
      orders_relapse_window.anchor_orders_with_30d_relapse,
      orders_relapse_window.rapid_relapse_shoppers,
      orders_relapse_window.avg_relapse_days_within_30d
    ]
    filters: [relapse_30d_orders.order_id: "NOT NULL"]
  }
}
