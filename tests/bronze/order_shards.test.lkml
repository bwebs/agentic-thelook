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
