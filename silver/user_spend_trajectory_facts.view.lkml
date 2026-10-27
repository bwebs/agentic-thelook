include: "/silver/explores/order_items.explore.lkml"

view: user_spend_trajectory_facts {
  label: "Customer Spend Trajectory Facts"

  derived_table: {
    explore_source: order_items {
      column: order_id { field: orders.order_id }
      column: user_id { field: orders.user_id }
      column: created_raw { field: orders.created_timestamp }
      column: order_total { field: order_items.total_revenue }
      filters: [
        orders.order_id: "NOT NULL",
        orders.user_id: "NOT NULL"
      ]
      derived_column: user_order_count {
        sql: COUNT(order_id) OVER (PARTITION BY user_id) ;;
      }
      derived_column: order_sequence_number {
        sql: ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_raw ASC, order_id ASC) ;;
      }
      derived_column: first_order_total {
        sql: FIRST_VALUE(order_total) OVER (PARTITION BY user_id ORDER BY created_raw ASC, order_id ASC) ;;
      }
      derived_column: latest_order_total {
        sql: FIRST_VALUE(order_total) OVER (PARTITION BY user_id ORDER BY created_raw DESC, order_id DESC) ;;
      }
      derived_column: order_recency_rank {
        sql: ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY created_raw DESC, order_id DESC) ;;
      }
    }
  }

  dimension: order_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: user_id {
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_recency_rank {
    hidden: yes
    type: number
    sql: ${TABLE}.order_recency_rank ;;
  }

  dimension: order_sequence_number {
    label: "Customer Order Sequence Number"
    description: "Chronological purchase sequence step for the customer (1 = first order, 2 = second order, etc., ordered by created_at and order_id)."
    synonyms: ["order number", "purchase step number", "repeat order step"]
    type: number
    sql: ${TABLE}.order_sequence_number ;;
  }

  dimension: user_order_count {
    label: "Evaluated Order Count"
    description: "Total completed checkout orders with line items evaluated for customer spend trajectory."
    synonyms: ["repeat order count", "trajectory order count", "user total orders"]
    type: number
    sql: ${TABLE}.user_order_count ;;
  }

  dimension: order_total {
    label: "Evaluated Order Spend"
    description: "Total gross dollar value of line items inside this evaluated customer order."
    synonyms: ["order spend", "step order spend"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.order_total ;;
  }

  dimension: first_order_total {
    label: "First Order Spend"
    description: "Total dollar value of the customer's very first order."
    synonyms: ["first basket spend", "initial order total", "first order spend"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.first_order_total ;;
  }

  dimension: latest_order_total {
    label: "Latest Order Spend"
    description: "Total dollar value of the customer's most recent order."
    synonyms: ["most recent order spend", "latest basket total"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.latest_order_total ;;
  }

  dimension: spend_escalation_multiplier {
    label: "Order Spend Escalation Multiplier"
    description: "Ratio of this order's dollar spend to the customer's baseline first-order spend (order_total / NULLIF(first_order_total, 0))."
    synonyms: ["escalation multiplier", "order to first order spend ratio"]
    type: number
    value_format_name: decimal_3
    sql: ${order_total} / NULLIF(${first_order_total}, 0) ;;
  }

  dimension: trajectory_ratio {
    label: "Latest-to-First Order Spend Ratio"
    description: "Ratio of the customer's most recent order total to their very first order total (latest_order_total / first_order_total)."
    synonyms: ["spend trajectory ratio", "basket growth ratio"]
    type: number
    value_format_name: decimal_2
    sql: SAFE_DIVIDE(${latest_order_total}, ${first_order_total}) ;;
  }

  dimension: spend_trajectory_persona {
    label: "Customer Spend Trajectory Persona"
    description: "Customer Spend Trajectory Persona compares the dollar value of a repeat customer's most recent order against their very first order, classifying them as Big-Spender Escalators whose latest basket grew by at least 25 percent, Steady-Eddie Flatliners, or Wallet-Fatigue Deflators whose latest order shrank by 25 percent or more. Account retention teams use this trajectory tag to spot deflating repeat buyers before they churn."
    synonyms: ["spend trajectory persona", "customer spend trajectory persona", "repeat buyer trajectory", "wallet fatigue persona"]
    case: {
      when: {
        sql: ${user_order_count} >= 2 AND ${trajectory_ratio} >= 1.25 ;;
        label: "Big-Spender Escalator (Latest >= 1.25x First Order)"
      }
      when: {
        sql: ${user_order_count} >= 2 AND (${trajectory_ratio} > 0.75 OR ${trajectory_ratio} IS NULL) ;;
        label: "Steady-Eddie Flatliner (0.75x - 1.25x)"
      }
      when: {
        sql: ${user_order_count} >= 2 AND ${trajectory_ratio} <= 0.75 ;;
        label: "Wallet-Fatigue Deflator (Latest <= 0.75x First Order)"
      }
    }
  }

  measure: count {
    label: "Evaluated Trajectory Orders"
    description: "Count of evaluated customer orders with line items."
    synonyms: ["trajectory orders count", "customers at step"]
    type: count
    filters: [order_id: "NOT NULL"]
  }

  measure: avg_order_spend {
    label: "Average Step Order Spend"
    description: "Mean gross dollar value of customer orders at the evaluated purchase sequence step."
    synonyms: ["avg order spend", "average step spend"]
    tags: ["non_additive"]
    type: average
    sql: ${order_total} ;;
    value_format_name: usd
  }

  measure: avg_first_order_spend {
    label: "Average First Order Spend"
    description: "Mean dollar value of the customer's very first order."
    synonyms: ["avg first order spend", "average initial order spend", "avg baseline first order spend"]
    tags: ["non_additive"]
    type: average
    sql: ${first_order_total} ;;
    value_format_name: usd
  }

  measure: avg_latest_order_spend {
    label: "Average Latest Order Spend"
    description: "Mean dollar value of the customer's most recent order."
    synonyms: ["avg latest order spend", "average recent order spend"]
    tags: ["non_additive"]
    type: average
    sql: ${latest_order_total} ;;
    value_format_name: usd
  }

  measure: avg_spend_escalation_multiplier {
    label: "Second-Order Price Escalation Multiplier"
    description: "Second-Order Price Escalation Multiplier compares how much repeat customers spend on their second, third, and subsequent orders relative to the baseline dollar amount of their very first order (AVG(order_spend / NULLIF(first_order_spend, 0))). Growth marketers use this escalation curve to see whether customers who start with a small introductory purchase ramp up their basket size on follow-up visits."
    synonyms: ["avg spend escalation multiplier", "price escalation multiplier", "second order price escalation multiplier"]
    tags: ["non_additive"]
    type: average
    sql: ${spend_escalation_multiplier} ;;
    value_format_name: decimal_3
  }
}
