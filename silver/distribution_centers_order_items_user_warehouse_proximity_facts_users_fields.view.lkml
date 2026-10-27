view: distribution_centers_order_items_user_warehouse_proximity_facts_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${order_items.id} ;;
  }

  dimension: wasted_detour_km {
    label: "Wasted Warehouse Detour Distance (km)"
    group_label: "Geospatial Freight & Corridors"
    description: "Extra straight-line shipping distance in kilometers incurred when fulfilling an order item from the actual origin warehouse compared to the customer's closest physical distribution center."
    synonyms: ["extra detour km", "wasted detour km", "excess shipping km"]
    type: number
    value_format_name: decimal_2
    sql: ${distribution_centers_order_items_users_fields.shipment_distance_km} - ${user_warehouse_proximity_facts.nearest_dc_km} ;;
  }

  measure: avg_wasted_detour_km {
    label: "Average Wasted Detour Distance per Item (km)"
    description: "Logistics Routing Absurdity Tax benchmark: mean excess straight-line kilometers traveled per item beyond the customer's closest physical distribution center."
    synonyms: ["avg wasted detour km per item", "avg extra km", "average excess detour km"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_2
    sql: ${wasted_detour_km} ;;
  }

  measure: total_wasted_detour_km {
    label: "Total Wasted Detour Distance (km)"
    description: "Logistics Routing Absurdity Tax total unnecessary shipping kilometers accumulated across items fulfilled from non-nearest warehouses."
    synonyms: ["total wasted detour km", "cumulative excess shipping km"]
    type: sum
    value_format_name: decimal_0
    sql: ${wasted_detour_km} ;;
  }
}
