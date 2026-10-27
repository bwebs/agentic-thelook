include: "/silver/explores/order_items.explore.lkml"

view: category_brand_facts {
  label: "Category Brand Concentration Facts"

  derived_table: {
    explore_source: order_items {
      column: category { field: products.category }
      column: brand { field: products.brand }
      column: units_sold { field: order_items.count }
      column: brand_revenue { field: order_items.total_revenue }
      filters: [products.id: "NOT NULL"]
      derived_column: brand_rank {
        sql: DENSE_RANK() OVER (PARTITION BY category ORDER BY brand_revenue DESC) ;;
      }
    }
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(COALESCE(${category}, ''), ':', COALESCE(${brand}, '')) ;;
  }

  dimension: category {
    label: "Product Category"
    description: "Clothing category evaluated for brand revenue concentration."
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: brand {
    label: "Brand"
    description: "Brand selling products within the clothing category."
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: units_sold {
    label: "Category-Brand Units Sold"
    description: "Cumulative ordered units sold by the brand within the clothing category."
    type: number
    sql: ${TABLE}.units_sold ;;
  }

  dimension: brand_revenue {
    label: "Category-Brand Revenue"
    description: "Cumulative gross dollar sales captured by the brand within the clothing category."
    type: number
    value_format_name: usd
    sql: ${TABLE}.brand_revenue ;;
  }

  dimension: brand_rank {
    label: "Within-Category Brand Revenue Rank"
    description: "Dense rank of the brand's cumulative gross revenue within its clothing category (1 = top-selling brand in category)."
    synonyms: ["brand rank", "category brand rank"]
    type: number
    sql: ${TABLE}.brand_rank ;;
  }

  dimension: is_top_3_brand {
    label: "Top 3 Ruling Category Brand"
    description: "Whether the brand ranks among the top three revenue-generating brands inside its clothing category (brand_rank <= 3)."
    synonyms: ["is top 3 brand", "oligopoly ruling brand"]
    type: yesno
    sql: ${brand_rank} <= 3 ;;
  }

  measure: count {
    label: "Active Category Brands"
    description: "Count of active revenue-generating brands within the clothing category."
    synonyms: ["active brands", "active category brands", "total active brands in cat"]
    type: count
    filters: [brand: "-NULL"]
  }

  measure: total_category_revenue {
    label: "Category Revenue"
    description: "Total gross dollar revenue generated across all brands in the clothing category."
    synonyms: ["category revenue", "total category revenue"]
    type: sum
    value_format_name: usd
    sql: ${brand_revenue} ;;
  }

  measure: top_3_brands_revenue {
    label: "Top 3 Brands Revenue"
    description: "Cumulative gross dollar revenue captured by the top three bestselling brands inside the clothing category."
    synonyms: ["top 3 brands revenue", "oligopoly revenue"]
    type: sum
    value_format_name: usd
    sql: ${brand_revenue} ;;
    filters: [is_top_3_brand: "yes"]
  }

  measure: top_3_monopoly_share {
    label: "Category Monopoly Concentration (Top 3 Brand Share)"
    description: "Category Monopoly Concentration calculates what share of total revenue inside each clothing category is captured by its top three bestselling brands. Category buyers use this concentration score to see which departments are dominated by a handful of heavyweight brands and which ones are wide open to niche labels."
    synonyms: ["top 3 monopoly share", "top 3 monopoly share pct", "category monopoly concentration"]
    tags: ["non_additive"]
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${top_3_brands_revenue} / NULLIF(${total_category_revenue}, 0) ;;
  }

  measure: oligopoly_ruling_brands {
    label: "Oligopoly Ruling Brands (Top 3)"
    description: "Ordered comma-separated roster of the top three bestselling brands and their ranks (#1, #2, #3) inside each clothing category."
    synonyms: ["oligopoly ruling brands", "top 3 ruling brands", "category ruling brands"]
    tags: ["non_additive"]
    type: string
    sql: STRING_AGG(CASE WHEN ${is_top_3_brand} THEN CONCAT('#', CAST(${brand_rank} AS STRING), ' ', ${brand}) END, ', ' ORDER BY ${brand_rank}) ;;
  }
}
