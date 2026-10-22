include: "../../bronze/explores/inventory_items_base.explore.lkml"

test: inventory_items_base_refinement_metrics {
  explore_source: inventory_items_base {
    column: inventory_item_count { field: inventory_items.count }
    column: sunk_dusty_shelf_cost { field: inventory_items.sunk_dusty_shelf_cost }
    column: hypothetical_retail_value { field: inventory_items.hypothetical_retail_value }
    filters: {
      field: inventory_items.created_date
      value: "2024-01-01"
    }
  }
  assert: inventory_item_count_matches {
    expression: ${inventory_items.count} = 188 ;;
  }
  assert: sunk_dusty_shelf_cost_matches {
    expression: round(${inventory_items.sunk_dusty_shelf_cost}, 2) = 3031.82 ;;
  }
  assert: hypothetical_retail_value_matches {
    expression: round(${inventory_items.hypothetical_retail_value}, 2) = 6389.09 ;;
  }
}
