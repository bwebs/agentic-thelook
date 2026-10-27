include: "/silver/category_brand_facts.view.lkml"

explore: category_brand_facts {
  label: "Category Brand Concentration"
  view_name: category_brand_facts
  hidden: no

  query: category_monopoly_concentration {
    description: "Top 20 clothing categories ranked by Category Monopoly Concentration (share of category revenue captured by the top three bestselling brands) alongside active brands and ruling brand names."
    dimensions: [category_brand_facts.category]
    measures: [
      category_brand_facts.count,
      category_brand_facts.total_category_revenue,
      category_brand_facts.top_3_brands_revenue,
      category_brand_facts.top_3_monopoly_share,
      category_brand_facts.oligopoly_ruling_brands
    ]
    sorts: [category_brand_facts.top_3_monopoly_share: desc]
    limit: 20
  }
}
