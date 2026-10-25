include: "order_shards.view.lkml"

view: +order_shards {
  dimension: table_suffix {
    label: "Wildcard Order Shard"
    description: "BigQuery _TABLE_SUFFIX identifying the matched order shard ('s' for orders, '_items' for order_items)."
    synonyms: ["wildcard order shard", "order shard"]
    type: string
    sql: ${TABLE}._TABLE_SUFFIX ;;
  }

  dimension_group: created {
    description: "Timestamp when the order or line item record was created (use SARGable date range filters rather than DATE() wrappers; required default window via always_filter)."
  }

  measure: count {
    label: "Shard Record Count"
    description: "Total record count across matched order wildcard shards (orders and order_items)."
    synonyms: ["shard records", "record count"]
  }

  measure: approx_distinct_users {
    label: "Approximate Distinct Users"
    description: "HyperLogLog approximate count of distinct shoppers (user_id) across matched order wildcard shards."
    synonyms: ["approx distinct users", "approximate unique users"]
    tags: ["non_additive"]
    type: number
    sql: APPROX_COUNT_DISTINCT(${user_id}) ;;
    value_format_name: decimal_0
  }
}
