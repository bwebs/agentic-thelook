include: "orders.view.lkml"

view: +orders {
  dimension: user_id {
    tags: ["foreign_key"]
  }

  dimension: num_of_item {
    label: "Basket Size (Items in Order)"
    description: "Number of items packed into a single order (basket size)."
    synonyms: ["basket size"]
  }

  dimension: is_mega_basket_bulk_order {
    label: "Mega-Basket Bulk Order"
    description: "Mega-Basket Bulk Order flags any single checkout where the customer packed three or more items into their order. Warehouse fulfillment teams use this tag to route multi-item purchases to larger box-packing stations."
    synonyms: ["is mega-basket bulk order", "mega basket bulk order", "mega-basket bulk orders", "bulk order", "multi-item purchase"]
    type: yesno
    sql: ${num_of_item} >= 3 ;;
  }

  # ponytail: raw UTC TIMESTAMP projection/sort key for microsecond SQL parity; remove once pre_gate.py normalizes BigQuery TIMESTAMP strings against created_time
  dimension: created_timestamp {
    label: "Created Timestamp (UTC)"
    group_label: "Created Date"
    description: "Exact UTC microsecond timestamp when the order was created."
    synonyms: ["order created timestamp"]
    sql: ${created_raw} ;;
  }

  measure: count {
    label: "Order Count"
    description: "Total volume of customer orders."
    synonyms: ["orders at this size", "order volume"]
  }

  measure: distinct_users {
    label: "Distinct Buying Users"
    description: "Number of distinct customers who have placed at least one order."
    synonyms: ["buying users", "distinct buyers", "purchasing customers"]
    type: count_distinct
    tags: ["non_additive"]
    sql: ${user_id} ;;
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

  measure: total_items {
    label: "Total Items in Orders"
    description: "Total count of individual items packed across orders (sum of num_of_item)."
    synonyms: ["total items involved", "items in orders"]
    alias: [_num_of_item_sum]
    type: sum
    sql: ${num_of_item} ;;
  }

  measure: cancelled_or_returned_orders {
    label: "Buyer's Remorse Order Volume (Cancelled or Returned)"
    description: "Buyer's Remorse Order Volume: count of customer orders that ended up cancelled or returned."
    synonyms: ["buyer's remorse order volume", "remorseful orders", "heartbreak metric"]
    type: count
    filters: [status: "Cancelled, Returned"]
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
          GREATEST(${_num_of_item_sum_of_squares} - (POWER(${total_items}, 2) / NULLIF(${_num_of_item_count}, 0)), 0)
          / NULLIF(${_num_of_item_count} - 1, 0)
         ) ;;
    value_format_name: decimal_3
  }
}
