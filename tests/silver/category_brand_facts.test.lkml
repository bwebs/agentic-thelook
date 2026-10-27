include: "../../silver/explores/category_brand_facts.explore.lkml"

test: category_brand_facts_monopoly_concentration_invariants {
  explore_source: category_brand_facts {
    column: category { field: category_brand_facts.category }
    column: count { field: category_brand_facts.count }
    column: total_category_revenue { field: category_brand_facts.total_category_revenue }
    column: top_3_brands_revenue { field: category_brand_facts.top_3_brands_revenue }
    column: top_3_monopoly_share { field: category_brand_facts.top_3_monopoly_share }
    column: oligopoly_ruling_brands { field: category_brand_facts.oligopoly_ruling_brands }
    filters: [category_brand_facts.category: "Jeans,Sweaters"]
  }
  assert: concentration_bounds_and_ratio_valid {
    expression: ${category_brand_facts.count} >= 3
      AND ${category_brand_facts.top_3_brands_revenue} > 0
      AND ${category_brand_facts.top_3_brands_revenue} <= ${category_brand_facts.total_category_revenue}
      AND round(${category_brand_facts.top_3_monopoly_share}, 6) = round(${category_brand_facts.top_3_brands_revenue} / ${category_brand_facts.total_category_revenue}, 6)
      AND NOT is_null(${category_brand_facts.oligopoly_ruling_brands}) ;;
  }
}
