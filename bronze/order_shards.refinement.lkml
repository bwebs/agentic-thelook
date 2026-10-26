include: "order_shards.view.lkml"

view: +order_shards {
  dimension: table_suffix {
    label: "Wildcard Order Shard"
    description: "BigQuery _TABLE_SUFFIX identifying the matched order shard ('s' for orders, '_items' for order_items)."
    synonyms: ["wildcard order shard", "order shard"]
    type: string
    sql: ${TABLE}._TABLE_SUFFIX ;;
  }

  dimension: wildcard_table_grain {
    label: "Wildcard Order Shard Grain"
    description: "Classifies records from the order* wildcard table by _TABLE_SUFFIX into 'Order Header Shard (orders)', 'Order Line-Item Shard (order_items)', and 'Other Wildcard Shard'."
    synonyms: ["wildcard table grain", "order shard grain", "shard table type"]
    case: {
      when: {
        sql: ${table_suffix} = 's' ;;
        label: "Order Header Shard (orders)"
      }
      when: {
        sql: ${table_suffix} = '_items' ;;
        label: "Order Line-Item Shard (order_items)"
      }
      else: "Other Wildcard Shard"
    }
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
