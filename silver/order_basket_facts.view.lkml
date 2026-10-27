include: "/silver/explores/order_items.explore.lkml"

view: order_basket_facts {
  label: "Order Basket Composition Facts"

  derived_table: {
    explore_source: order_items {
      column: order_id { field: orders.order_id }
      column: total_units { field: order_items.count }
      column: distinct_categories { field: products.distinct_categories }
      column: distinct_brands { field: products.distinct_brands }
      column: basket_spend { field: order_items.total_revenue }
      filters: [
        orders.order_id: "NOT NULL",
        products.id: "NOT NULL"
      ]
      derived_column: store_total_orders {
        sql: COUNT(*) OVER () ;;
      }
    }
  }

  dimension: order_id {
    primary_key: yes
    label: "Evaluated Basket Order ID"
    description: "Unique order identifier for orders with evaluated product line items."
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: total_units {
    label: "Basket Total Units"
    group_label: "Basket Composition"
    description: "Total number of line item units packed inside the order basket."
    synonyms: ["units in basket", "order item units"]
    type: number
    sql: ${TABLE}.total_units ;;
  }

  dimension: distinct_categories {
    label: "Basket Distinct Categories"
    group_label: "Basket Composition"
    description: "Count of distinct clothing categories packed inside the order basket."
    synonyms: ["categories in basket", "order distinct categories"]
    type: number
    sql: ${TABLE}.distinct_categories ;;
  }

  dimension: distinct_brands {
    label: "Basket Distinct Brands"
    group_label: "Basket Composition"
    description: "Count of distinct product brands packed inside the order basket."
    synonyms: ["brands in basket", "order distinct brands"]
    type: number
    sql: ${TABLE}.distinct_brands ;;
  }

  dimension: basket_spend {
    label: "Basket Gross Spend"
    group_label: "Basket Composition"
    description: "Total gross sale price summed across all line items in the order basket."
    synonyms: ["order basket spend", "basket total revenue"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.basket_spend ;;
  }

  dimension: basket_diversity_archetype {
    label: "Outfit Builder versus Monoculture Hoarder Basket Archetype"
    group_label: "Basket Composition"
    description: "Outfit Builder versus Monoculture Hoarder Basket Archetype classifies every order by the variety of clothing categories inside the box: Head-to-Toe Complete Outfit Builders buying three or more distinct categories at once, Dual-Category Mix-and-Matchers, Monoculture Category Hoarders buying multiple items from the exact same category, and Solo Item Snipers (returns NULL for orders without line items). Cross-sell and bundle promotion teams use this basket archetype to pitch complete-the-look outfit discounts to single-category shoppers."
    synonyms: ["basket diversity archetype", "outfit builder vs monoculture hoarder", "order basket archetype", "category mix basket tier"]
    case: {
      when: {
        sql: ${order_id} IS NOT NULL AND ${total_units} != 1 AND ${distinct_categories} NOT IN (1, 2) ;;
        label: "Head-to-Toe Complete Outfit Builder (3+ Distinct Categories)"
      }
      when: {
        sql: ${total_units} != 1 AND ${distinct_categories} = 2 ;;
        label: "Dual-Category Mix-and-Matcher (2 Categories)"
      }
      when: {
        sql: ${total_units} != 1 AND ${distinct_categories} = 1 ;;
        label: "Monoculture Category Hoarder (2+ Units, All Same Category)"
      }
      when: {
        sql: ${total_units} = 1 ;;
        label: "Solo Item Sniper (1 Unit Total)"
      }
    }
  }

  measure: avg_basket_units {
    label: "Average Units in Basket"
    description: "Mean number of line item units packed per evaluated order basket."
    synonyms: ["avg units in basket", "average basket units"]
    tags: ["non_additive"]
    type: average
    sql: ${total_units} ;;
    value_format_name: decimal_2
  }

  measure: avg_basket_distinct_brands {
    label: "Average Distinct Brands in Basket"
    description: "Mean number of distinct brands packed per evaluated order basket."
    synonyms: ["avg distinct brands", "average brands per basket"]
    tags: ["non_additive"]
    type: average
    sql: ${distinct_brands} ;;
    value_format_name: decimal_2
  }

  measure: avg_basket_spend {
    label: "Average Basket Spend"
    description: "Average gross dollar value per evaluated order basket."
    synonyms: ["avg basket spend", "average order basket value"]
    tags: ["non_additive"]
    type: average
    sql: ${basket_spend} ;;
    value_format_name: usd
  }

  measure: total_basket_revenue {
    label: "Total Basket Revenue"
    description: "Total gross dollar revenue summed across evaluated order baskets."
    synonyms: ["total archetype revenue", "summed basket spend"]
    type: sum
    sql: ${basket_spend} ;;
    value_format_name: usd
  }

  dimension: _store_total_orders {
    hidden: yes
    type: number
    sql: ${TABLE}.store_total_orders ;;
  }

  measure: store_evaluated_orders {
    label: "Store Total Evaluated Orders"
    description: "Store-wide count of distinct orders containing evaluated catalog product items, used as the baseline denominator for market basket lift."
    synonyms: ["n orders", "total evaluated basket orders"]
    tags: ["non_additive"]
    type: max
    sql: ${_store_total_orders} ;;
  }
}
