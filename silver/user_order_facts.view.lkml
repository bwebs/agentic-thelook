include: "/silver/explores/orders.explore.lkml"

view: user_order_facts {
  label: "Customer Order Facts"

  derived_table: {
    explore_source: orders {
      column: user_id { field: orders.user_id }
      column: lifetime_orders { field: orders.count }
      column: lifetime_items { field: orders.total_items }
      column: first_order_micros { field: orders._first_order_micros }
      column: last_order_micros { field: orders._last_order_micros }
      column: max_inter_order_gap_days { field: orders_sequenced.max_inter_order_gap_days }
      filters: [orders.user_id: "NOT NULL"]
      derived_column: dataset_latest_order_micros {
        sql: MAX(last_order_micros) OVER () ;;
      }
    }
  }

  dimension: user_id {
    primary_key: yes
    label: "Ordering Customer User ID"
    description: "Unique customer identifier for shoppers who have placed at least one order."
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension_group: first_order {
    label: "Customer First Order"
    description: "Timestamp of the customer's very first order."
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: TIMESTAMP_MICROS(${TABLE}.first_order_micros) ;;
  }

  dimension_group: last_order {
    label: "Customer Latest Order"
    description: "Timestamp of the customer's most recent order."
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: TIMESTAMP_MICROS(${TABLE}.last_order_micros) ;;
  }

  dimension_group: dataset_latest_order {
    hidden: yes
    type: time
    timeframes: [raw]
    sql: TIMESTAMP_MICROS(${TABLE}.dataset_latest_order_micros) ;;
  }

  dimension_group: since_first_order_ref {
    label: "Since First Order (Dataset Clock)"
    description: "Elapsed days from the customer's first order to the latest order timestamp recorded in the store ledger."
    type: duration
    intervals: [day]
    sql_start: ${first_order_raw} ;;
    sql_end: ${dataset_latest_order_raw} ;;
  }

  dimension_group: since_last_order_ref {
    label: "Since Latest Order (Dataset Clock)"
    description: "Elapsed days from the customer's most recent order to the latest order timestamp recorded in the store ledger."
    type: duration
    intervals: [day]
    sql_start: ${last_order_raw} ;;
    sql_end: ${dataset_latest_order_raw} ;;
  }

  dimension: max_inter_order_gap_days {
    label: "Customer Max Inter-Order Gap (Days)"
    description: "Longest dormancy gap in whole days between consecutive orders in the customer's order history (0 for single-order or non-ordering users)."
    synonyms: ["max inter order gap days", "max hibernation gap days"]
    type: number
    sql: COALESCE(${TABLE}.max_inter_order_gap_days, 0) ;;
  }

  dimension: lifetime_orders {
    label: "Customer Lifetime Orders"
    description: "Total lifetime orders placed by the customer (0 for non-purchasing registered accounts)."
    synonyms: ["total orders", "lifetime order count"]
    type: number
    sql: COALESCE(${TABLE}.lifetime_orders, 0) ;;
  }

  dimension: lifetime_items {
    label: "Customer Lifetime Items in Orders"
    description: "Total lifetime items ordered across all orders placed by the customer (0 for non-purchasing registered accounts)."
    synonyms: ["total items", "lifetime items ordered"]
    type: number
    sql: COALESCE(${TABLE}.lifetime_items, 0) ;;
  }

  dimension: customer_loyalty_tier {
    label: "One-and-Done Tourist versus Loyal Repeat Regular"
    description: "One-and-Done Tourist versus Loyal Repeat Regular classifies every registered user by their lifetime order count into 'Window-Shopping Ghost (0 Orders)', 'One-and-Done Tourist (1 Order)', 'Repeat Double-Dipper (2 Orders)', and 'Cult Die-Hard Regular (3+ Orders)'. Retention marketers use this loyalty ladder to target first-time buyers with second-purchase incentives while rewarding multi-order regulars."
    synonyms: ["customer loyalty tier", "one-and-done tourist vs loyal repeat regular", "repeat buyer loyalty ladder", "order frequency loyalty tier"]
    case: {
      when: {
        sql: ${lifetime_orders} = 0 ;;
        label: "Window-Shopping Ghost (0 Orders)"
      }
      when: {
        sql: ${lifetime_orders} = 1 ;;
        label: "One-and-Done Tourist (1 Order)"
      }
      when: {
        sql: ${lifetime_orders} = 2 ;;
        label: "Repeat Double-Dipper (2 Orders)"
      }
      else: "Cult Die-Hard Regular (3+ Orders)"
    }
  }
}
