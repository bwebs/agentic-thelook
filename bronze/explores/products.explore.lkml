include: "../products.view.lkml"
include: "../products.refinement.lkml"

explore: products {
  label: "Products"
  view_name: products
  hidden: no

  query: avg_sticker_price {
    description: "Average Sticker Shock measures the simple average retail sticker price across every item in our product catalog, regardless of how often it sells. The merchandising team uses this benchmark in board meetings to position the store as an affordable luxury destination."
    measures: [products.avg_sticker_price]
  }

  query: catalog_markup_by_department {
    description: "Catalog Markup Greed Ratio and average dollar markup across departments."
    dimensions: [products.department]
    measures: [
      products.count,
      products.avg_dollar_markup,
      products.avg_markup_greed_pct
    ]
  }

  query: top_categories_by_markup_greed {
    description: "Top 15 clothing categories and departments ranked by Catalog Markup Greed Ratio."
    dimensions: [
      products.category,
      products.department
    ]
    measures: [
      products.count,
      products.avg_markup_greed_pct
    ]
    sorts: [products.avg_markup_greed_pct: desc]
    limit: 15
  }

  query: catalog_assortment_by_price_tier {
    description: "Catalog SKU count, average retail sticker price, and average wholesale cost across Product Price Tier Taxonomy brackets."
    dimensions: [products.price_tier]
    measures: [
      products.count,
      products.avg_sticker_price,
      products.avg_wholesale_cost
    ]
    sorts: [products.price_tier: asc]
  }
}
