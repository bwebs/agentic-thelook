view: order_items_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${users.id} AS STRING), '_', CAST(COALESCE(${order_items.id}, 0) AS STRING)) ;;
  }

  measure: avg_activity_weighted_user_age {
    label: "Average Activity-Weighted User Age"
    description: "Mean shopper age across joined user and order-item rows (weights multi-item buyers by item count and zero-purchase users once)."
    type: average
    tags: ["non_additive"]
    sql: ${users.age} ;;
    value_format_name: decimal_1
  }

  measure: revenue_per_registered_user {
    label: "Revenue per Registered User"
    description: "Country Per-Capita Fashion Spend measures average gross sales spend per registered customer across countries and marketing channels."
    synonyms: ["country per-capita fashion spend", "average spend per registered customer", "per capita fashion spend"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${order_items.total_revenue} / NULLIF(${users.count}, 0) ;;
    value_format_name: usd
  }
}
