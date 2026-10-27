view: order_items_category_cooccurrence {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${order_items.id} AS STRING), '_', CAST(COALESCE(${paired_order_items.id}, 0) AS STRING)) ;;
  }

  dimension: has_paired_category {
    hidden: yes
    type: yesno
    sql: ${paired_products.id} IS NOT NULL ;;
  }

  measure: pair_orders {
    label: "Co-Occurring Basket Orders"
    description: "Count of distinct customer orders containing at least one item from both clothing categories in the pair."
    synonyms: ["pair orders", "co-occurring orders", "joint category orders"]
    tags: ["non_additive"]
    type: count_distinct
    sql: ${order_items.order_id} ;;
    filters: [has_paired_category: "yes"]
  }

  measure: co_occurrence_lift_score {
    label: "Market Basket Odd-Couple Co-Occurrence Lift"
    description: "Market Basket Odd-Couple Co-Occurrence Lift ((pair_orders * total_orders) / (cat_a_orders * cat_b_orders)) measures how much more often two clothing categories are purchased together in the same checkout basket than independent chance predicts. Merchandising and recommendation teams use these category-pair lift scores to power cross-sell widgets and bundle suggestions at checkout."
    synonyms: ["co occurrence lift score", "market basket odd-couple co-occurrence lift", "category pair lift", "basket lift score"]
    tags: ["non_additive"]
    type: number
    value_format_name: decimal_3
    sql: (1.0 * ${pair_orders} * ${order_basket_facts.store_evaluated_orders}) / NULLIF(1.0 * ${category_sales_facts.category_orders} * ${paired_category_sales_facts.category_orders}, 0) ;;
  }
}
