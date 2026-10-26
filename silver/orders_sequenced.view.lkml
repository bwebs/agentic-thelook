include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"

view: orders_sequenced {
  extends: [orders]
  label: "Order Sequence & Inter-Order Gaps"

  derived_table: {
    sql:
      SELECT
        {{ order_id._sql }} AS order_id,
        {{ created_raw._sql }} AS created_at,
        LAG({{ created_raw._sql }}) OVER (
          PARTITION BY {{ user_id._sql }}
          ORDER BY {{ created_raw._sql }} ASC
        ) AS prev_order_at
      FROM ${orders.SQL_TABLE_NAME} AS {{ _table }} ;;
  }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: prev_order {
    label: "Previous Order"
    description: "Timestamp of the customer's immediately preceding order marking when hibernation started."
    synonyms: ["hibernation started at", "prior order timestamp"]
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}.prev_order_at ;;
  }

  # ponytail: type: number instead of dimension_group type: duration so lkr schema validate accepts numeric ">=180" filter expressions (duration_day currently routes to date filter regex)
  dimension: days_inter_order_gap {
    label: "Days in Inter-Order Hibernation"
    description: "Elapsed whole days in dormancy between the customer's previous order and this order."
    synonyms: ["days in hibernation", "order gap days", "inter order gap days"]
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.created_at, ${prev_order_raw}, DAY) ;;
  }

  measure: max_inter_order_gap_days {
    label: "Max Inter-Order Gap (Days)"
    description: "Longest dormancy gap in whole days between any two consecutive orders placed by the customer (0 for single-order buyers)."
    synonyms: ["max inter order gap days", "longest hibernation days", "max order gap days"]
    tags: ["non_additive"]
    type: max
    sql: COALESCE(${days_inter_order_gap}, 0) ;;
  }
}
