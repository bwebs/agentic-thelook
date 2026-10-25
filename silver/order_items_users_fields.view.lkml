view: order_items_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${users.id} AS STRING), '_', CAST(COALESCE(${order_items.id}, 0) AS STRING)) ;;
  }

  dimension: years_since_signup {
    label: "Years Since Signup"
    description: "Number of calendar years elapsed between the customer's cohort signup year and the order item purchase year (UTC)."
    synonyms: ["customer tenure years", "tenure years", "vintage year offset"]
    type: number
    sql: EXTRACT(YEAR FROM ${order_items.created_raw}) - ${users.cohort_signup_year} ;;
  }

  measure: avg_activity_weighted_user_age {
    label: "Average Activity-Weighted User Age"
    description: "Mean shopper age across joined user and order-item rows (weights multi-item buyers by item count and zero-purchase users once)."
    type: average
    tags: ["non_additive"]
    sql: ${users.age} ;;
    value_format_name: decimal_1
  }

  measure: avg_activity_weighted_abs_latitude {
    label: "Average Activity-Weighted Absolute Latitude"
    description: "Mean absolute customer latitude across joined user and order-item rows (weights multi-item buyers by item count and zero-purchase users once)."
    type: average
    tags: ["non_additive"]
    sql: ${users.abs_latitude} ;;
    value_format_name: decimal_2
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

  measure: latitude_price_correlation {
    label: "Latitude-Price Correlation"
    description: "Pearson correlation coefficient between customer absolute latitude (distance from the equator) and ordered item sale price."
    synonyms: ["latitude price correlation", "abs latitude sale price correlation"]
    type: number
    tags: ["non_additive"]
    sql: CORR(${users.abs_latitude}, ${order_items.sale_price}) ;;
    value_format_name: decimal_4
  }

  measure: age_price_correlation {
    label: "Age-Price Correlation"
    description: "Pearson correlation coefficient between customer age and ordered item sale price."
    synonyms: ["age price correlation", "customer age sale price correlation"]
    type: number
    tags: ["non_additive"]
    sql: CORR(${users.age}, ${order_items.sale_price}) ;;
    value_format_name: decimal_4
  }
}
