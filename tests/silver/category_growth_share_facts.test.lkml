include: "../../silver/explores/category_growth_share_facts.explore.lkml"

test: category_growth_share_portfolio_invariants {
  explore_source: category_growth_share_facts {
    column: bcg_growth_share_quadrant { field: category_growth_share_facts.bcg_growth_share_quadrant }
    column: count { field: category_growth_share_facts.count }
    column: total_active_skus { field: category_growth_share_facts.total_active_skus }
    column: total_quadrant_revenue { field: category_growth_share_facts.total_quadrant_revenue }
    column: total_quadrant_profit { field: category_growth_share_facts.total_quadrant_profit }
    column: avg_category_margin_rate { field: category_growth_share_facts.avg_category_margin_rate }
    column: flagship_categories { field: category_growth_share_facts.flagship_categories }
    filters: [category_growth_share_facts.department: "Men,Women"]
  }
  assert: quadrant_counts_and_skus_positive {
    expression: NOT is_null(${category_growth_share_facts.bcg_growth_share_quadrant})
      AND ${category_growth_share_facts.count} > 0
      AND ${category_growth_share_facts.total_active_skus} >= ${category_growth_share_facts.count} ;;
  }
  assert: quadrant_financials_and_flagships_bounded {
    expression: ${category_growth_share_facts.total_quadrant_revenue} > ${category_growth_share_facts.total_quadrant_profit}
      AND ${category_growth_share_facts.total_quadrant_profit} > 0
      AND ${category_growth_share_facts.avg_category_margin_rate} > 0
      AND ${category_growth_share_facts.avg_category_margin_rate} < 1
      AND length(${category_growth_share_facts.flagship_categories}) > 0 ;;
  }
}
