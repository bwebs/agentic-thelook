include: "../../silver/explores/inventory_items.explore.lkml"

test: inventory_items_refinement_metrics {
  explore_source: inventory_items {
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

test: inventory_items_2024_01_01_turnover_metrics {
  explore_source: inventory_items {
    column: sold_units { field: inventory_items.sold_units }
    column: unsold_units { field: inventory_items.unsold_units }
    column: sell_through_rate { field: inventory_items.sell_through_rate }
    column: avg_days_on_shelf { field: inventory_items.avg_days_on_shelf }
    column: total_cost { field: inventory_items.total_cost }
    filters: {
      field: inventory_items.sold_date
      value: "2024-01-01"
    }
  }
  assert: sold_units_matches {
    expression: ${inventory_items.sold_units} = 80 ;;
  }
  assert: unsold_units_matches {
    expression: ${inventory_items.unsold_units} = 0 ;;
  }
  assert: sell_through_rate_matches {
    expression: round(${inventory_items.sell_through_rate}, 4) = 1 ;;
  }
  assert: avg_days_on_shelf_matches {
    expression: round(${inventory_items.avg_days_on_shelf}, 2) = 29.95 ;;
  }
  assert: total_cost_matches {
    expression: round(${inventory_items.total_cost}, 2) = 2152.29 ;;
  }
}
