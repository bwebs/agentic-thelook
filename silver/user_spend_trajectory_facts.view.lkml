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

  dimension: user_order_count {
    label: "Evaluated Order Count"
    description: "Total completed checkout orders with line items evaluated for customer spend trajectory."
    synonyms: ["repeat order count", "trajectory order count"]
    type: number
    sql: ${TABLE}.user_order_count ;;
  }

  dimension: first_order_total {
    label: "First Order Spend"
    description: "Total dollar value of the customer's very first order."
    synonyms: ["first basket spend", "initial order total"]
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

  measure: avg_first_order_spend {
    label: "Average First Order Spend"
    description: "Mean dollar value of the customer's very first order."
    synonyms: ["avg first order spend", "average initial order spend"]
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
}
