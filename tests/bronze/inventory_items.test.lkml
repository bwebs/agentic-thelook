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

test: inventory_items_2024_01_01_unsold_shelf_sitter_invariants {
  explore_source: inventory_items {
    column: count { field: inventory_items.count }
    column: unsold_units { field: inventory_items.unsold_units }
    column: sold_units { field: inventory_items.sold_units }
    column: total_cost { field: inventory_items.total_cost }
    column: sunk_dusty_shelf_cost { field: inventory_items.sunk_dusty_shelf_cost }
    filters: {
      field: inventory_items.created_date
      value: "2024-01-01"
    }
    filters: {
      field: inventory_items.is_sold
      value: "no"
    }
  }
  assert: shelf_sitter_count_non_negative {
    expression: ${inventory_items.count} >= 0 ;;
  }
  assert: unsold_units_match_shelf_sitter_count {
    expression: ${inventory_items.unsold_units} = ${inventory_items.count} ;;
  }
  assert: zero_sold_units_in_shelf_sitter_slice {
    expression: ${inventory_items.sold_units} = 0 ;;
  }
  assert: shelf_sitter_cost_matches_sunk_cost {
    expression: coalesce(round(${inventory_items.total_cost}, 2), 0) = coalesce(round(${inventory_items.sunk_dusty_shelf_cost}, 2), 0) AND coalesce(${inventory_items.total_cost}, 0) >= 0 ;;
  }
}

test: inventory_items_sold_2024_01_01_aging_tier_metrics {
  explore_source: inventory_items {
    column: inventory_aging_tier { field: inventory_items.inventory_aging_tier }
    column: sold_units { field: inventory_items.sold_units }
    column: total_cost { field: inventory_items.total_cost }
    filters: {
      field: inventory_items.is_sold
      value: "yes"
    }
    filters: {
      field: inventory_items.sold_date
      value: "2024-01-01"
    }
    sorts: [inventory_items.inventory_aging_tier: asc]
  }
  assert: sold_aging_tier_matches {
    expression: ${inventory_items.inventory_aging_tier} = "Fresh Off the Truck (<90 Days)" ;;
  }
  assert: sold_units_and_cost_match {
    expression: ${inventory_items.sold_units} = 55 AND round(${inventory_items.total_cost}, 2) = 1413.30 ;;
  }
}

test: inventory_items_sold_2024_01_01_stddev_days_on_shelf {
  explore_source: inventory_items {
    column: sold_units { field: inventory_items.sold_units }
    column: avg_days_on_shelf { field: inventory_items.avg_days_on_shelf }
    column: stddev_days_on_shelf { field: inventory_items.stddev_days_on_shelf }
    filters: [
      inventory_items.sold_date: "2024-01-01",
      inventory_items.is_sold: "yes"
    ]
  }
  assert: sold_units_matches {
    expression: ${inventory_items.sold_units} = 63 ;;
  }
  assert: stddev_days_on_shelf_matches {
    expression: round(${inventory_items.stddev_days_on_shelf}, 2) = 17.01 ;;
  }
}
