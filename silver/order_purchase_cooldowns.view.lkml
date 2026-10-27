include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"

view: order_purchase_cooldowns {
  extends: [orders]
  label: "Order Purchase Cooldowns"

  derived_table: {
    sql:
      SELECT
        {{ order_id._sql }} AS order_id,
        {{ created_raw._sql }} AS created_at,
        ROW_NUMBER() OVER (
          PARTITION BY {{ user_id._sql }}
          ORDER BY {{ created_raw._sql }} ASC
        ) AS order_seq,
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

  dimension: order_sequence {
    label: "Repeat Purchase Sequence Milestone"
    description: "Chronological order number for the customer (1 = first purchase, 2 = second purchase, etc., ordered by created_at)."
    synonyms: ["order seq", "purchase milestone", "repeat order sequence"]
    type: number
    sql: ${TABLE}.order_seq ;;
  }

  dimension: is_repeat_order {
    label: "Repeat Purchase Order"
    description: "Whether the order is a repeat purchase preceded by an earlier order from the same customer."
    synonyms: ["is repeat order", "has prior order"]
    type: yesno
    sql: ${TABLE}.prev_order_at IS NOT NULL ;;
  }

  dimension: _cooldown_minutes {
    hidden: yes
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.created_at, ${TABLE}.prev_order_at, MINUTE) ;;
  }

  dimension: _cooldown_hours {
    hidden: yes
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.created_at, ${TABLE}.prev_order_at, HOUR) ;;
  }

  dimension: cooldown_days {
    label: "Inter-Order Cooldown (Whole Days)"
    description: "Whole days elapsed between the customer's immediately preceding order and this order."
    synonyms: ["cooldown days", "days between orders"]
    type: number
    sql: TIMESTAMP_DIFF(${TABLE}.created_at, ${TABLE}.prev_order_at, DAY) ;;
  }

  measure: repeat_orders {
    label: "Repeat Orders"
    description: "Count of repeat customer orders that follow a prior purchase (excluding first-time orders)."
    synonyms: ["repeat orders count", "repeat transitions"]
    type: count
    filters: [is_repeat_order: "yes"]
  }

  measure: avg_dopamine_cooldown_days {
    label: "Inter-Order Dopamine Cooldown (Days)"
    description: "Inter-Order Dopamine Cooldown measures the average fractional days (hours / 24) elapsed between a customer's consecutive orders."
    synonyms: ["avg dopamine cooldown days", "inter-order dopamine cooldown", "average cooldown days"]
    tags: ["non_additive"]
    type: average
    sql: ${_cooldown_hours} / 24.0 ;;
    value_format_name: decimal_2
  }

  measure: min_cooldown_hours {
    label: "Minimum Inter-Order Cooldown (Hours)"
    description: "Shortest elapsed time in fractional hours (minutes / 60) between consecutive orders."
    synonyms: ["min cooldown hours", "fastest repeat order hours"]
    tags: ["non_additive"]
    type: min
    sql: ${_cooldown_minutes} / 60.0 ;;
    value_format_name: decimal_2
  }

  measure: max_cooldown_days {
    label: "Maximum Inter-Order Cooldown (Days)"
    description: "Longest elapsed whole-day cooldown gap between consecutive orders."
    synonyms: ["max cooldown days", "longest repeat cooldown days"]
    tags: ["non_additive"]
    type: max
    sql: ${cooldown_days} ;;
    value_format_name: decimal_2
  }

  measure: avg_whole_cooldown_days {
    label: "Average Whole Days Between Orders"
    description: "Mean whole-day interval (TIMESTAMP_DIFF DAY) between consecutive repeat customer orders."
    synonyms: ["avg days between orders", "average days between orders"]
    tags: ["non_additive"]
    type: average
    sql: ${cooldown_days} ;;
    value_format_name: decimal_2
  }
}
