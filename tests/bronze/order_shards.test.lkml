include: "../../bronze/explores/order_shards.explore.lkml"

test: order_shards_2024_01_01_metrics {
  explore_source: order_shards {
    column: shard_records { field: order_shards.count }
    column: approx_distinct_users { field: order_shards.approx_distinct_users }
    filters: {
      field: order_shards.table_suffix
      value: "s, ^_items"
    }
    filters: {
      field: order_shards.created_date
      value: "2024-01-01"
    }
  }
  assert: shard_records_matches {
    expression: ${order_shards.count} = 117 ;;
  }
  assert: approx_distinct_users_matches {
    expression: ${order_shards.approx_distinct_users} = 73 ;;
  }
}

test: order_shards_2024_01_01_wildcard_table_grain {
  explore_source: order_shards {
    column: wildcard_table_grain { field: order_shards.wildcard_table_grain }
    column: count { field: order_shards.count }
    filters: [
      order_shards.table_suffix: "s, ^_items",
      order_shards.created_date: "2024-01-01"
    ]
    sorts: [order_shards.wildcard_table_grain: asc]
  }
  assert: wildcard_table_grain_counts_match {
    expression: index(${order_shards.wildcard_table_grain}, 1) = "Order Header Shard (orders)"
      AND index(${order_shards.count}, 1) = 52
      AND index(${order_shards.wildcard_table_grain}, 2) = "Order Line-Item Shard (order_items)"
      AND index(${order_shards.count}, 2) = 55 ;;
  }
}
