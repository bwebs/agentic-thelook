include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/explores/products_base.explore.lkml"
include: "/silver/product_sales_facts.view.lkml"

explore: products {
  extends: [products_base]
  label: "Products"
  view_name: products
  hidden: no

  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${products.id} = ${order_items.product_id} ;;
  }

  join: product_sales_facts {
    view_label: "Product Sales Velocity Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${products.id} = ${product_sales_facts.product_id} ;;
  }

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

  query: products_by_gross_margin_tier {
    description: "Catalog SKU count, average retail sticker price, and average unit dollar profit across Gross Margin Cash-Cow Tier quadrants."
    dimensions: [products.gross_margin_tier]
    measures: [
      products.count,
      products.avg_sticker_price,
      products.avg_dollar_markup
    ]
    sorts: [products.gross_margin_tier: asc]
  }

  query: products_by_wardrobe_anatomy_zone {
    description: "Distinct clothing categories, catalog SKU count, and average retail sticker price across Wardrobe Anatomy Zone body coverage zones."
    dimensions: [products.wardrobe_anatomy_zone]
    measures: [
      products.distinct_categories,
      products.count,
      products.avg_sticker_price
    ]
    sorts: [products.wardrobe_anatomy_zone: asc]
  }

  query: top_categories_by_sku_count_and_price_range {
    description: "Top 20 clothing category and department combinations ranked by SKU count alongside minimum and maximum retail sticker prices."
    dimensions: [
      products.category,
      products.department
    ]
    measures: [
      products.count,
      products.min_retail_price,
      products.max_retail_price
    ]
    sorts: [products.count: desc]
    limit: 20
  }

  query: catalog_by_sku_velocity_tier {
    description: "Catalog SKU count, total units sold, and gross revenue across Bestseller Hero versus Zero-Sale Wallflower velocity tiers."
    dimensions: [product_sales_facts.sku_velocity_tier]
    measures: [
      products.count,
      order_items.count,
      order_items.total_revenue
    ]
    sorts: [product_sales_facts.sku_velocity_tier: asc]
  }

  query: top_selling_hero_skus {
    description: "Top 15 best-selling catalog product SKUs ranked by units sold and gross revenue."
    dimensions: [
      products.id,
      products.name,
      products.brand,
      products.category
    ]
    measures: [
      order_items.count,
      order_items.total_revenue
    ]
    filters: [order_items.id: "NOT NULL"]
    sorts: [
      order_items.count: desc,
      order_items.total_revenue: desc
    ]
    limit: 15
  }
}
