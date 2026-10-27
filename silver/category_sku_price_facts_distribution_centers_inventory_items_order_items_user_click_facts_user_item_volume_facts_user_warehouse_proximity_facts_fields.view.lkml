view: category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${order_items.id} ;;
  }

  dimension: is_shipped_from_nearest_dc {
    label: "Shipped from Nearest Warehouse"
    description: "Whether the ordered item shipped out of the physical distribution center closest to the customer's home coordinates."
    synonyms: ["shipped from nearest dc", "optimal warehouse routing match"]
    type: yesno
    sql: ${distribution_centers.name} = ${user_warehouse_proximity_facts.nearest_warehouse_name} ;;
  }

  dimension: order_line_archetype {
    label: "Grand Unified Full-Stack Order-Line Archetype"
    description: "The Grand Unified Full-Stack Order-Line Archetype classifies every transaction in the company by combining product price positioning, net profit margin, local-warehouse routing accuracy, delivery speed, inventory shelf age, customer repeat loyalty, and multi-channel browsing into six end-to-end transaction archetypes: Golden Couture Jackpots, Hyper-Local Express Triumphs, Lazarus Dead-Stock Clearance Miracles, Omnichannel Cult Loyalist Restocks, Long-Haul Workhorse Standard Fulfillments, and Boomerang Heartbreak Reversals. Executive leadership uses this flagship transaction taxonomy to slice company revenue and retained profit by the full story of how each item was browsed, priced, stocked, routed, and delivered."
    synonyms: [
      "grand unified 7 table order archetype",
      "grand unified full-stack order-line archetype",
      "order line archetype",
      "full-stack transaction archetype"
    ]
    case: {
      when: {
        sql: NOT ${order_items.is_reversed} AND ${category_sku_price_facts.category_price_z_score} >= 1.5 AND SAFE_DIVIDE(${order_items.sale_price} - ${inventory_items.cost}, ${order_items.sale_price}) >= 0.55 ;;
        label: "Golden Couture Jackpot (Luxury Outlier Z>=1.5, 55%+ Margin, Kept)"
      }
      when: {
        sql: NOT ${order_items.is_reversed} AND ${is_shipped_from_nearest_dc} AND COALESCE(${order_items.hours_total_doorstep_wait}, 999) <= 72 ;;
        label: "Hyper-Local Express Triumph (Nearest Warehouse & <=72h Delivery)"
      }
      when: {
        sql: NOT ${order_items.is_reversed} AND COALESCE(${inventory_items.days_on_shelf}, 0) >= 730 ;;
        label: "Lazarus Dead-Stock Clearance Miracle (Sold After 2+ Years on Shelf)"
      }
      when: {
        sql: NOT ${order_items.is_reversed} AND COALESCE(${user_item_volume_facts.buyer_lifetime_items}, 0) >= 4 AND COALESCE(${user_click_facts.distinct_event_sources}, 1) >= 2 ;;
        label: "Omnichannel Cult Loyalist Restock (4+ Lifetime Items, Multi-Channel)"
      }
      when: {
        sql: NOT ${order_items.is_reversed} ;;
        label: "Long-Haul Workhorse Standard Fulfillment (Core Global Commerce)"
      }
      else: "Boomerang Heartbreak Reversal (Returned or Cancelled Transaction)"
    }
  }

  measure: optimal_nearest_warehouse_shipments {
    label: "Optimal Nearest-Warehouse Shipments"
    description: "Count of shipped order items fulfilled out of the physical distribution center geographically closest to the customer's home coordinates."
    synonyms: ["optimal nearest warehouse shipments", "closest warehouse shipments"]
    type: count
    filters: [
      is_shipped_from_nearest_dc: "yes",
      distribution_centers.id: "NOT NULL",
      user_warehouse_proximity_facts.id: "NOT NULL"
    ]
  }

  measure: suboptimal_detour_shipments {
    label: "Suboptimal Detour Shipments"
    description: "Count of shipped order items fulfilled from a non-closest warehouse rather than the distribution center nearest to the customer's home."
    synonyms: ["suboptimal detour shipments", "mismatched warehouse shipments", "detoured shipments"]
    type: count
    filters: [
      is_shipped_from_nearest_dc: "no",
      distribution_centers.id: "NOT NULL",
      user_warehouse_proximity_facts.id: "NOT NULL"
    ]
  }

  measure: routing_absurdity_rate {
    label: "Logistics Routing Absurdity Rate"
    description: "Logistics Routing Absurdity Tax share of shipments fulfilled from a suboptimal non-nearest distribution center rather than the warehouse geographically closest to the customer's home."
    synonyms: ["routing absurdity rate", "routing absurdity rate pct", "logistics routing absurdity tax", "detour shipment rate"]
    tags: ["non_additive"]
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${suboptimal_detour_shipments} / NULLIF(${order_items.count}, 0) ;;
  }
}
