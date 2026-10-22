include: "../../bronze/explores/inventory_items_base.explore.lkml"

test: inventory_items_base_refinement_metrics {
  explore_source: inventory_items_base {
    column: inventory_item_count { field: inventory_items.count }
    column: total_cost { field: inventory_items.total_cost }
    column: sunk_dusty_shelf_cost { field: inventory_items.sunk_dusty_shelf_cost }
    column: total_product_retail_price { field: inventory_items.total_product_retail_price }
    column: hypothetical_retail_value { field: inventory_items.hypothetical_retail_value }
    filters: {
      field: inventory_items.created_date
      value: "2024-01-01"
    }
  }
  assert: inventory_item_count_matches {
    expression: ${inventory_items.count} = 188 ;;
  }
  assert: total_cost_matches {
    expression: round(${inventory_items.total_cost}, 2) = 4711.29 ;;
  }
  assert: sunk_dusty_shelf_cost_matches {
    expression: ${inventory_items.sunk_dusty_shelf_cost} = 4711.29 ;;
  }
  assert: total_product_retail_price_matches {
    expression: round(${inventory_items.total_product_retail_price}, 2) = 9927.51 ;;
  }
  assert: hypothetical_retail_value_matches {
    expression: ${inventory_items.hypothetical_retail_value} = 9927.51 ;;
  }
}
