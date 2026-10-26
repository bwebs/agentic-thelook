view: orders_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${users.id} AS STRING), '_', CAST(COALESCE(${orders.order_id}, 0) AS STRING)) ;;
  }

  dimension_group: from_signup_to_order {
    label: "From Signup to Order"
    description: "Elapsed time between customer account creation and order placement."
    type: duration
    intervals: [day]
    sql_start: ${users.created_raw} ;;
    sql_end: ${orders.created_raw} ;;
  }

  dimension: is_post_signup_order {
    label: "Post-Signup Order"
    description: "Whether the order timestamp occurred on or after the customer's account creation timestamp."
    synonyms: ["order on or after signup", "post signup order"]
    type: yesno
    sql: ${orders.created_raw} >= ${users.created_raw} ;;
  }

  measure: avg_days_from_signup_to_order {
    label: "Average Days from Signup to Order"
    description: "Mean whole days elapsed from customer account signup to order placement across orders."
    synonyms: ["avg days from signup to order", "mean signup to order days"]
    tags: ["non_additive"]
    type: average
    sql: ${days_from_signup_to_order} ;;
    value_format_name: decimal_1
  }

  measure: ghost_users {
    label: "Ghost Users"
    description: "Number of registered customers who created an account on the site but have never placed a single order."
    synonyms: ["dormant signups", "window shoppers", "non-buying users"]
    type: count_distinct
    tags: ["non_additive"]
    sql: ${users.id} ;;
    filters: [orders.order_id: "NULL"]
  }

  measure: ghost_account_rate {
    label: "Ghost Account Window-Shopper Rate"
    description: "Ghost Account Window-Shopper Rate calculates the share of registered customers who created an account on the site but have never placed a single order. Email marketers use this metric to size the dormant signup pool and trigger first-purchase welcome discounts."
    synonyms: ["ghost account rate", "ghost account rate pct", "ghost pct", "window-shopper rate"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${ghost_users} / NULLIF(${users.count}, 0) ;;
    value_format_name: percent_2
  }
}
