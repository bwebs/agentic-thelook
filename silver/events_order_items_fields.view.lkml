view: events_order_items_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(COALESCE(${events.id}, 0) AS STRING), '_', CAST(COALESCE(${order_items.id}, 0) AS STRING)) ;;
  }

  measure: clicks_per_item_bought {
    label: "Clicks per Item Bought"
    description: "Ratio of total clickstream events to total order items purchased (returns NULL when zero items are bought)."
    synonyms: ["clicks per item", "click to item ratio"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${events.count} / NULLIF(${order_items.count}, 0) ;;
    value_format_name: decimal_2
  }

  measure: total_event_weighted_revenue {
    label: "Total Event-Weighted Item Revenue"
    description: "Un-deduplicated FLOAT64 sum of ordered item sale prices weighted across joined user clickstream events and order-item rows."
    tags: ["non_additive"]
    type: number
    sql: COALESCE(SUM(${order_items.sale_price}), 0) ;;
    value_format_name: usd
  }
}
