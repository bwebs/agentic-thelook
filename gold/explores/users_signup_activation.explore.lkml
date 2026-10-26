include: "/silver/explores/users.explore.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/gold/users_signup_activation.view.lkml"

explore: users_signup_activation {
  extends: [users]
  label: "Users (Signup Activation Cohort)"
  view_name: users
  hidden: no
  tags: ["gold"]

  sql_always_where: {% condition users_signup_activation.signup_cohort_window %} ${users.created_raw} {% endcondition %} ;;

  always_filter: {
    filters: [users_signup_activation.signup_cohort_window: "2024/01/01 to 2026/01/01"]
  }

  join: rolling_7d_orders {
    from: orders
    view_label: "7-Day Rolling Window Orders"
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${rolling_7d_orders.user_id}
      AND ${rolling_7d_orders.created_raw} >= ${users.created_raw}
      AND ${rolling_7d_orders.created_raw} <= TIMESTAMP_ADD(${users.created_raw}, INTERVAL 7 DAY) ;;
  }

  join: users_signup_activation {
    view_label: "Users"
    sql: ;;
    relationship: one_to_one
  }

  query: signup_cohort_7d_conversion_by_traffic_source {
    description: "Cohort user count by acquisition traffic source and 7-day rolling conversion window outcome."
    dimensions: [
      users.traffic_source,
      users_signup_activation.rolling_7d_window_outcome
    ]
    measures: [users.count]
    filters: [users_signup_activation.signup_cohort_window: "2024/01/01 to 2026/01/01"]
    sorts: [
      users.traffic_source: asc,
      users_signup_activation.rolling_7d_window_outcome: asc
    ]
  }
}
