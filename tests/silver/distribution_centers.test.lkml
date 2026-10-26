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
