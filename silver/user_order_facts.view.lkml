include: "/bronze/explores/orders.explore.lkml"

view: user_order_facts {
  label: "Customer Order Facts"

  derived_table: {
    explore_source: orders {
      column: user_id { field: orders.user_id }
      column: lifetime_orders { field: orders.count }
      column: lifetime_items { field: orders.total_items }
      filters: [orders.user_id: "NOT NULL"]
    }
  }

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
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
