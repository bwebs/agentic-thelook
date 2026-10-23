include: "orders.view.lkml"

view: +orders {
  dimension: num_of_item {
    label: "Basket Size (Items in Order)"
    description: "Number of items packed into a single order (basket size)."
    synonyms: ["basket size"]
  }

  measure: count {
    label: "Order Count"
    description: "Total volume of customer orders."
    synonyms: ["orders at this size", "order volume"]
  }

  measure: avg_items_per_order {
    label: "Average Items per Order"
    description: "Cart Stuffing Velocity: average number of items customers pack into a single order."
    type: average
    sql: ${num_of_item} ;;
    value_format_name: decimal_3
  }

  measure: max_items_per_order {
    label: "Max Items per Order"
    description: "Maximum number of items packed into a single order."
    synonyms: ["max items crammed"]
    type: max
    sql: ${num_of_item} ;;
  }

  measure: stddev_items_per_order {
    label: "Basket Size Standard Deviation (Jitter)"
    description: "Spread (sample standard deviation) of how many items customers pack into a single order."
    synonyms: ["basket size jitter", "cart stuffing spread"]
    type: number
    sql: STDDEV(${num_of_item}) ;;
    value_format_name: decimal_3
  }
}
