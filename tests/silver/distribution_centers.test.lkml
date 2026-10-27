include: "../../silver/explores/distribution_centers.explore.lkml"

test: distribution_centers_id_1_flagship_specialty_invariants {
  explore_source: distribution_centers {
    column: categories_in_tier { field: warehouse_category_facts.count }
    column: total_sold_units { field: warehouse_category_facts.total_sold_units }
    column: total_category_revenue { field: warehouse_category_facts.total_category_revenue }
    column: top_signature_categories { field: warehouse_category_facts.top_signature_categories }
    filters: [
      distribution_centers.id: "1",
      warehouse_category_facts.warehouse_specialty_tier: "Flagship Signature Crown Category (#1)"
    ]
  }
  assert: flagship_specialty_invariants_hold {
    expression: ${warehouse_category_facts.count} >= 1
      AND ${warehouse_category_facts.total_sold_units} > 0
      AND ${warehouse_category_facts.total_category_revenue} > 0
      AND NOT is_null(${warehouse_category_facts.top_signature_categories}) ;;
  }
}

test: distribution_centers_gravity_well_invariants {
  explore_source: distribution_centers {
    column: warehouse_count { field: warehouse_inventory_facts.count }
    column: total_distinct_skus_stocked { field: warehouse_inventory_facts.total_distinct_skus_stocked }
    column: total_warehouse_capital_deployed { field: warehouse_inventory_facts.total_warehouse_capital_deployed }
    column: total_dead_stock_drag { field: warehouse_inventory_facts.total_dead_stock_drag }
    column: avg_warehouse_turn_days { field: warehouse_inventory_facts.avg_warehouse_turn_days }
    column: total_fulfilled_order_items { field: warehouse_fulfillment_facts.total_fulfilled_order_items }
    column: return_drag_rate { field: warehouse_fulfillment_facts.return_drag_rate }
    column: net_profit_per_1000_shipment_km { field: warehouse_fulfillment_facts.net_profit_per_1000_shipment_km }
    filters: [
      warehouse_inventory_facts.dc_id: "NOT NULL",
      warehouse_fulfillment_facts.dc_id: "NOT NULL"
    ]
  }
  assert: capital_and_dead_stock_bounds {
    expression: ${warehouse_inventory_facts.count} >= 1 AND ${warehouse_inventory_facts.total_distinct_skus_stocked} > 0 AND ${warehouse_inventory_facts.total_warehouse_capital_deployed} >= ${warehouse_inventory_facts.total_dead_stock_drag} AND ${warehouse_inventory_facts.total_dead_stock_drag} >= 0 ;;
  }
  assert: fulfillment_and_gravity_well_bounds {
    expression: ${warehouse_fulfillment_facts.total_fulfilled_order_items} > 0 AND ${warehouse_fulfillment_facts.return_drag_rate} >= 0 AND ${warehouse_fulfillment_facts.return_drag_rate} <= 1 AND ${warehouse_fulfillment_facts.net_profit_per_1000_shipment_km} > 0 AND ${warehouse_inventory_facts.avg_warehouse_turn_days} > 0 ;;
  }
}
