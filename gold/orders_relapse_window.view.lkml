view: orders_relapse_window {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${orders.order_id} AS STRING), '_', CAST(COALESCE(${relapse_30d_orders.order_id}, 0) AS STRING)) ;;
  }

  dimension: has_30d_relapse {
    hidden: yes
    type: yesno
    sql: ${relapse_30d_orders.order_id} IS NOT NULL ;;
  }

  dimension: relapse_cooldown_days {
    label: "30-Day Relapse Cooldown (Days)"
    description: "Fractional days (hours / 24) elapsed between the anchor order and a follow-up purchase placed within 30 days."
    synonyms: ["relapse cooldown days", "30d follow-up gap days"]
    type: number
    value_format_name: decimal_2
    sql: TIMESTAMP_DIFF(${relapse_30d_orders.created_raw}, ${orders.created_raw}, HOUR) / 24.0 ;;
  }

  measure: anchor_orders_with_30d_relapse {
    label: "Anchor Orders with 30-Day Relapse"
    description: "Number of distinct customer orders that triggered at least one rapid follow-up purchase within 30 days."
    synonyms: ["anchor orders with 30d relapse", "orders triggering 30d follow-up"]
    tags: ["non_additive"]
    type: count_distinct
    sql: ${orders.order_id} ;;
    filters: [has_30d_relapse: "yes"]
  }

  measure: rapid_relapse_shoppers {
    label: "Rapid-Relapse Binge Shoppers (30-Day Window)"
    description: "Number of distinct customers who placed a rapid follow-up purchase within 30 days of an anchor order."
    synonyms: ["rapid relapse binge shoppers", "30d repeat shoppers"]
    tags: ["non_additive"]
    type: count_distinct
    sql: ${orders.user_id} ;;
    filters: [has_30d_relapse: "yes"]
  }

  measure: avg_relapse_days_within_30d {
    label: "Average 30-Day Relapse Cooldown (Days)"
    description: "Average fractional days elapsed between an anchor order and follow-up purchases placed within a 30-day window."
    synonyms: ["avg relapse days within 30d window", "average 30d relapse days"]
    tags: ["non_additive"]
    type: average
    sql: ${relapse_cooldown_days} ;;
    filters: [has_30d_relapse: "yes"]
    value_format_name: decimal_2
  }
}
