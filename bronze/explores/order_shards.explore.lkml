include: "../order_shards.view.lkml"
include: "../order_shards.refinement.lkml"

explore: order_shards {
  label: "Order Shards (Wildcard)"
  view_name: order_shards
  hidden: no

  always_filter: {
    filters: [
      order_shards.table_suffix: "s, ^_items",
      order_shards.created_date: "7 days"
    ]
  }

  sql_always_where:
    {% if order_shards.table_suffix._is_filtered %}
      {% condition order_shards.table_suffix %} ${order_shards.table_suffix} {% endcondition %}
    {% else %}
      ${order_shards.table_suffix} IN ('s', '_items')
    {% endif %} ;;

  query: order_shard_status_volume {
    description: "Record volume and approximate distinct shoppers across orders ('s') and order_items ('_items') wildcard shards since 2020-01-01."
    dimensions: [order_shards.table_suffix, order_shards.status]
    measures: [order_shards.count, order_shards.approx_distinct_users]
    filters: [
      order_shards.table_suffix: "s, ^_items",
      order_shards.created_date: "after 2020/01/01"
    ]
    sorts: [order_shards.table_suffix: asc, order_shards.count: desc]
  }
}
