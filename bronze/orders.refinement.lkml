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

  measure: _num_of_item_count {
    hidden: yes
    type: count_distinct
    sql: ${order_id} ;;
    filters: [num_of_item: "NOT NULL"]
  }

  measure: _num_of_item_sum {
    hidden: yes
    type: sum
    sql: ${num_of_item} ;;
  }

  measure: _num_of_item_sum_of_squares {
    hidden: yes
    type: sum
    sql: POWER(${num_of_item}, 2) ;;
  }

  measure: stddev_items_per_order {
    label: "Basket Size Standard Deviation (Jitter)"
    description: "Spread (sample standard deviation) of how many items customers pack into a single order."
    synonyms: ["basket size jitter", "cart stuffing spread"]
    type: number
    sql: SQRT(
          GREATEST(${_num_of_item_sum_of_squares} - (POWER(${_num_of_item_sum}, 2) / NULLIF(${_num_of_item_count}, 0)), 0)
          / NULLIF(${_num_of_item_count} - 1, 0)
         ) ;;
    value_format_name: decimal_3
  }
}
