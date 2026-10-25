view: order_items_user_cohort_facts_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${user_cohort_facts.cohort_signup_year} AS STRING), '_', CAST(COALESCE(${order_items.id}, 0) AS STRING)) ;;
  }

  measure: buyer_activation_survival_rate {
    label: "Buyer Activation Survival Rate"
    description: "Annual Cohort Vintage Decay and Survival Matrix retention rate: share of original cohort signup users who remain active buyers in a given tenure year."
    synonyms: ["buyer activation survival pct", "cohort survival rate", "cohort retention rate", "vintage survival pct"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${order_items.distinct_users} / NULLIF(${user_cohort_facts.initial_cohort_users}, 0) ;;
    value_format_name: percent_2
  }

  measure: revenue_per_cohort_user {
    label: "Revenue per Original Cohort User"
    description: "Annual Cohort Vintage Decay and Survival Matrix monetization metric: gross order item revenue generated in a given tenure year divided by the original signup cohort size."
    synonyms: ["revenue per original cohort user", "cohort revenue per user", "vintage revenue per user"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${order_items.total_revenue} / NULLIF(${user_cohort_facts.initial_cohort_users}, 0) ;;
    value_format_name: usd
  }
}
