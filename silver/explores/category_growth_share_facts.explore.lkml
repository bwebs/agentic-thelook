include: "/silver/category_growth_share_facts.view.lkml"

explore: category_growth_share_facts {
  label: "Category Growth-Share Portfolio"
  view_name: category_growth_share_facts
  hidden: no

  query: portfolio_by_bcg_growth_share_quadrant {
    description: "Category count, active SKUs, cumulative revenue, cumulative profit, average category margin rate, and top 5 flagship categories across Product Lifecycle Stage Growth-Share Taxonomy quadrants."
    dimensions: [category_growth_share_facts.bcg_growth_share_quadrant]
    measures: [
      category_growth_share_facts.count,
      category_growth_share_facts.total_active_skus,
      category_growth_share_facts.total_quadrant_revenue,
      category_growth_share_facts.total_quadrant_profit,
      category_growth_share_facts.avg_category_margin_rate,
      category_growth_share_facts.flagship_categories
    ]
    sorts: [category_growth_share_facts.bcg_growth_share_quadrant: asc]
  }
}
