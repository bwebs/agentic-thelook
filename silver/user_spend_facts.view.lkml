include: "/bronze/explores/order_items_base.explore.lkml"

view: user_spend_facts {
  label: "Customer Spend Facts"

  derived_table: {
    explore_source: order_items_base {
      column: user_id { field: order_items.user_id }
      column: items_bought { field: order_items.count }
      column: lifetime_spend { field: order_items.total_revenue }
      filters: [order_items.user_id: "NOT NULL"]
    }
  }

  dimension: user_id {
    primary_key: yes
    label: "Paying Customer User ID"
    description: "Unique customer identifier for shoppers who have purchased at least one order item."
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: items_bought {
    label: "Customer Lifetime Items Bought"
    description: "Cumulative number of order items purchased across the customer's lifetime."
    synonyms: ["items bought", "lifetime items purchased"]
    type: number
    sql: ${TABLE}.items_bought ;;
  }

  dimension: lifetime_spend {
    label: "Customer Lifetime Spend"
    description: "Cumulative gross dollar spend across all order items purchased by the customer."
    synonyms: ["lifetime spend", "customer ltv", "cumulative spend"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.lifetime_spend ;;
  }

  dimension: oceanic_spend_tier {
    label: "Whale versus Minnow Customer Spend Tier"
    description: "Whale versus Minnow Customer Spend Tier segments paying customers by their cumulative lifetime dollar spend into four oceanic brackets: 'Plankton (<$30 LTV)', 'Minnow ($30-$99 LTV)', 'Dolphin ($100-$299 LTV)', and 'Moby Dick Mega-Whale ($300+ LTV)' (returns NULL for non-purchasing accounts). Customer service and loyalty teams use this spend tier to route Mega-Whales to priority support and exclusive VIP perks."
    synonyms: ["oceanic spend tier", "whale vs minnow customer spend tier", "customer spend tier", "ltv spend bracket"]
    case: {
      when: {
        sql: ${lifetime_spend} < 30.0 ;;
        label: "Plankton (<$30 LTV)"
      }
      when: {
        sql: ${lifetime_spend} < 100.0 ;;
        label: "Minnow ($30-$99 LTV)"
      }
      when: {
        sql: ${lifetime_spend} < 300.0 ;;
        label: "Dolphin ($100-$299 LTV)"
      }
      when: {
        sql: ${lifetime_spend} >= 300.0 ;;
        label: "Moby Dick Mega-Whale ($300+ LTV)"
      }
    }
  }

  measure: avg_customer_ltv {
    label: "Average Customer LTV"
    description: "Average cumulative lifetime dollar spend across paying customers."
    synonyms: ["tier avg ltv", "average lifetime spend", "avg buyer ltv"]
    tags: ["non_additive"]
    type: average
    sql: ${lifetime_spend} ;;
    value_format_name: usd
  }
}
