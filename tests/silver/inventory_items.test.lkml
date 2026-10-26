include: "../../silver/explores/inventory_items.explore.lkml"

test: inventory_items_2024_01_01_warehouse_turnover_metrics {
  explore_source: inventory_items {
    column: warehouse_name { field: distribution_centers.name }
    column: sold_units { field: inventory_items.sold_units }
    column: avg_days_on_shelf { field: inventory_items.avg_days_on_shelf }
    column: total_cost { field: inventory_items.total_cost }
    filters: {
      field: inventory_items.sold_date
      value: "2024-01-01"
    }
    filters: {
      field: distribution_centers.name
      value: "Memphis TN"
    }
  }
  assert: warehouse_name_matches {
    expression: ${distribution_centers.name} = "Memphis TN" ;;
  }
  assert: sold_units_matches {
    expression: ${inventory_items.sold_units} = 10 ;;
  }
  assert: avg_days_on_shelf_matches {
    expression: round(${inventory_items.avg_days_on_shelf}, 2) = 26.6 ;;
  }
  assert: total_cost_matches {
    expression: round(${inventory_items.total_cost}, 2) = 218.22 ;;
  }
}

test: inventory_items_2024_01_01_products_join_metrics {
  explore_source: inventory_items {
    column: distinct_categories { field: products.distinct_categories }
    column: count { field: inventory_items.count }
    column: sold_units { field: inventory_items.sold_units }
    column: unsold_units { field: inventory_items.unsold_units }
    filters: {
      field: inventory_items.created_date
      value: "2024-01-01"
    }
    filters: {
      field: products.id
      value: "NOT NULL"
    }
  }
  assert: distinct_categories_matches {
    expression: ${products.distinct_categories} = 25 ;;
  }
  assert: intake_unit_count_matches {
    expression: ${inventory_items.count} = 186 ;;
  }
  assert: sold_plus_unsold_equals_total_units {
    expression: ${inventory_items.sold_units} + ${inventory_items.unsold_units} = ${inventory_items.count} ;;
  }
}
