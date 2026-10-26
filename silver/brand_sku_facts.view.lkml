include: "/silver/explores/products_sales_base.explore.lkml"

view: brand_sku_facts {
  label: "Brand Lineup SKU Facts"

  derived_table: {
    explore_source: products_sales_base {
      column: product_id { field: products.id }
      column: brand { field: products.brand }
      column: retail_price { field: products.retail_price }
      column: units_sold { field: order_items.count }
      column: sku_revenue { field: order_items.total_revenue }
      filters: [products.brand: "-NULL"]
      derived_column: brand_total_skus {
        sql: COUNT(product_id) OVER (PARTITION BY brand) ;;
      }
      derived_column: price_rank_in_brand {
        sql: PERCENT_RANK() OVER (PARTITION BY brand ORDER BY retail_price DESC) ;;
      }
      derived_column: rev_rank_in_brand {
        sql: PERCENT_RANK() OVER (PARTITION BY brand ORDER BY COALESCE(sku_revenue, 0) DESC) ;;
      }
    }
  }

  dimension: product_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: brand {
    hidden: yes
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: retail_price {
    hidden: yes
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: units_sold {
    hidden: yes
    type: number
    sql: COALESCE(${TABLE}.units_sold, 0) ;;
  }

  dimension: sku_revenue {
    hidden: yes
    type: number
    sql: COALESCE(${TABLE}.sku_revenue, 0) ;;
  }

  dimension: brand_total_skus {
    label: "Brand Catalog SKU Count"
    group_label: "Brand Lineup Strategy"
    description: "Total number of catalog product SKUs carried by the product's brand."
    synonyms: ["brand total skus", "skus in brand"]
    type: number
    sql: ${TABLE}.brand_total_skus ;;
  }

  dimension: price_rank_in_brand {
    label: "Within-Brand Price Percent Rank"
    group_label: "Brand Lineup Strategy"
    description: "Relative price percentile rank (PERCENT_RANK) of the SKU within its brand ordered from highest to lowest retail sticker price (0.0 = most expensive in brand)."
    synonyms: ["price rank in brand", "brand price percentile"]
    type: number
    value_format_name: percent_2
    sql: ${TABLE}.price_rank_in_brand ;;
  }

  dimension: rev_rank_in_brand {
    label: "Within-Brand Revenue Percent Rank"
    group_label: "Brand Lineup Strategy"
    description: "Relative revenue percentile rank (PERCENT_RANK) of the SKU within its brand ordered from highest to lowest cumulative gross revenue (0.0 = top revenue seller in brand)."
    synonyms: ["rev rank in brand", "brand revenue percentile"]
    type: number
    value_format_name: percent_2
    sql: ${TABLE}.rev_rank_in_brand ;;
  }

  dimension: brand_lineup_strategic_role {
    label: "Brand Price-Anchoring Decoy versus Volume Workhorse Role"
    group_label: "Brand Lineup Strategy"
    description: "Brand Price-Anchoring Decoy versus Volume Workhorse Role classifies every item within its brand's catalog lineup into four strategic roles: Halo Prestige Price-Anchor Decoys sitting in the brand's top 15 percent highest prices with almost no unit sales, Flagship Revenue Workhorses driving the top quarter of brand sales, Entry-Level Gateway Bait in the cheapest 20 percent, and Mid-Tier Catalog Fillers (returns NULL when brand is missing). Pricing strategists use this lineup taxonomy to ensure brands have both an aspirational halo piece and high-volume workhorse items."
    synonyms: ["brand lineup strategic role", "brand price-anchoring decoy vs volume workhorse role", "halo decoy vs flagship workhorse", "brand catalog role"]
    case: {
      when: {
        sql: ${brand_total_skus} >= 5 AND ${price_rank_in_brand} <= 0.15 AND ${units_sold} <= 1 ;;
        label: "Halo Prestige Price-Anchor Decoy (Top 15% Price, <=1 Sold)"
      }
      when: {
        sql: ${rev_rank_in_brand} <= 0.25 AND ${units_sold} >= 1 ;;
        label: "Flagship Revenue Workhorse (Top 25% Brand Revenue)"
      }
      when: {
        sql: ${price_rank_in_brand} >= 0.80 ;;
        label: "Entry-Level Gateway Bait (Cheapest 20% in Brand)"
      }
      when: {
        sql: ${product_id} IS NOT NULL ;;
        label: "Mid-Tier Catalog Filler"
      }
    }
  }
}
