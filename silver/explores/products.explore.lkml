include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/bronze/products__name_tokens.view.lkml"
include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/explores/products_base.explore.lkml"
include: "/silver/explores/products_sales_base.explore.lkml"
include: "/silver/order_items_products_products__name_tokens_fields.view.lkml"
include: "/silver/product_sales_facts.view.lkml"
include: "/silver/product_inventory_facts.view.lkml"
include: "/silver/category_sku_price_facts.view.lkml"
include: "/silver/brand_facts.view.lkml"
include: "/silver/brand_sku_facts.view.lkml"

explore: products {
  extends: [products_sales_base]
  label: "Products"
  view_name: products
  hidden: no

  join: distribution_centers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
  }

  join: order_items_products_products__name_tokens_fields {
    view_label: "Products: Title Words"
    sql: ;;
    relationship: one_to_one
  }

  join: product_sales_facts {
    view_label: "Product Sales Velocity Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${products.id} = ${product_sales_facts.product_id} ;;
  }

  join: product_inventory_facts {
    view_label: "Product Inventory & Replenishment Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${products.id} = ${product_inventory_facts.product_id} ;;
  }

  join: category_sku_price_facts {
    view_label: "Category Price Outlier Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${products.id} = ${category_sku_price_facts.product_id} ;;
  }

  join: brand_facts {
    view_label: "Brand Prestige Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.brand} = ${brand_facts.brand} ;;
  }

  join: brand_sku_facts {
    view_label: "Brand Lineup SKU Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${products.id} = ${brand_sku_facts.product_id} ;;
  }

  query: top_product_title_buzzwords {
    description: "Top 20 descriptive product title buzzwords (4+ characters) ranked by gross attributed sales alongside distinct SKUs, units sold, and average word position in title."
    dimensions: [products__name_tokens.product_title_buzzword]
    measures: [
      products.count,
      order_items.count,
      order_items.total_revenue,
      products__name_tokens.avg_word_position_in_title
    ]
    filters: [
      order_items.id: "NOT NULL",
      products__name_tokens.token_length: ">=4"
    ]
    sorts: [order_items.total_revenue: desc]
    limit: 20
  }

  query: catalog_by_replenishment_urgency_tier {
    description: "Catalog SKU count, remaining unsold units, historical sold units, and unsold wholesale capital value across Product Stockout Risk and Replenishment Urgency Tiers."
    dimensions: [product_inventory_facts.replenishment_urgency_tier]
    measures: [
      products.count,
      product_inventory_facts.total_unsold_available_units,
      product_inventory_facts.total_sold_units,
      product_inventory_facts.total_unsold_capital_value
    ]
    filters: [distribution_centers.id: "NOT NULL"]
    sorts: [product_inventory_facts.replenishment_urgency_tier: asc]
  }

  query: catalog_by_category_price_outlier_term {
    description: "Catalog SKU count, average retail sticker price, and average within-category Z-score across Category Price Outlier Taxonomy tiers."
    dimensions: [category_sku_price_facts.category_price_outlier_term]
    measures: [
      products.count,
      products.avg_sticker_price,
      category_sku_price_facts.avg_category_price_z_score
    ]
    sorts: [category_sku_price_facts.category_price_outlier_term: asc]
  }

  query: top_category_price_outlier_unicorns {
    description: "Top 15 Overpriced Category Unicorn SKUs sitting 2.5+ standard deviations above their category average retail price."
    dimensions: [
      products.id,
      products.name,
      products.brand,
      products.category,
      products.retail_price,
      category_sku_price_facts.category_avg_retail_price,
      category_sku_price_facts.category_price_z_score
    ]
    filters: [category_sku_price_facts.category_price_z_score: ">=2.5"]
    sorts: [category_sku_price_facts.category_price_z_score: desc]
    limit: 15
  }

  query: catalog_by_brand_lineup_strategic_role {
    description: "Catalog SKU count, average retail sticker price, total units sold, gross revenue, and gross profit across Brand Price-Anchoring Decoy versus Volume Workhorse Roles."
    dimensions: [brand_sku_facts.brand_lineup_strategic_role]
    measures: [
      products.count,
      products.avg_sticker_price,
      product_sales_facts.total_units_sold,
      product_sales_facts.total_sku_revenue,
      product_sales_facts.total_sku_profit
    ]
    filters: [products.brand: "-NULL"]
    sorts: [brand_sku_facts.brand_lineup_strategic_role: asc]
  }

  query: catalog_by_brand_prestige_tier {
    description: "Distinct brands, catalog SKU count, total units sold, and gross revenue across Fast-Fashion versus Ultra-Luxury Brand Tiers."
    dimensions: [brand_facts.brand_prestige_tier]
    measures: [
      products.distinct_brands,
      products.count,
      order_items.count,
      order_items.total_revenue
    ]
    filters: [products.brand: "-NULL"]
    sorts: [brand_facts.brand_prestige_tier: asc]
  }

  query: top_selling_brands_by_retail_price {
    description: "Top 15 active selling brands (15+ units sold) ranked by average retail price alongside catalog SKUs, units sold, and total revenue."
    dimensions: [products.brand]
    measures: [
      products.count,
      order_items.count,
      products.avg_sticker_price,
      order_items.total_revenue
    ]
    filters: [
      order_items.id: "NOT NULL",
      order_items.count: ">=15"
    ]
    sorts: [products.avg_sticker_price: desc]
    limit: 15
  }

  query: catalog_brand_reach_by_department {
    description: "Distinct catalog brands, purchasing customers, and average units sold per catalog brand across product departments."
    dimensions: [products.department]
    measures: [
      products.distinct_brands,
      order_items.distinct_users,
      order_items_products_fields.avg_units_sold_per_brand
    ]
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
