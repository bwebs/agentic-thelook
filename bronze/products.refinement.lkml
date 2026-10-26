include: "products.view.lkml"

view: +products {
  dimension: dollar_markup {
    label: "Dollar Markup"
    description: "Unit retail sticker price minus unit wholesale cost (retail_price - cost)."
    type: number
    sql: ${retail_price} - ${cost} ;;
    value_format_name: usd
  }

  dimension: markup_greed_pct {
    label: "Catalog Markup Greed Ratio (%)"
    description: "Percentage markup of unit retail sticker price over unit wholesale cost ((retail_price - cost) / NULLIF(cost, 0) * 100)."
    type: number
    sql: ((${retail_price} - ${cost}) / NULLIF(${cost}, 0)) * 100 ;;
    value_format: "0.00\"%\""
  }

  dimension: price_tier {
    label: "Product Price Tier Taxonomy"
    description: "Product Price Tier Taxonomy buckets every catalog item by its retail sticker price into four clear brackets: 1. Impulse Pocket Change (<$25), 2. Everyday Mall Staple ($25-$75), 3. Treat-Yo-Self Designer ($75-$200), and 4. Trust-Fund Couture ($200+). Merchandising teams use these price tiers as sidebar shopping filters and to balance catalog assortment across budget levels."
    synonyms: ["product price tier taxonomy", "price tier term"]
    type: string
    sql: CASE
      WHEN ${retail_price} < 25.0 THEN '1. Impulse Pocket Change (<$25)'
      WHEN ${retail_price} < 75.0 THEN '2. Everyday Mall Staple ($25-$75)'
      WHEN ${retail_price} < 200.0 THEN '3. Treat-Yo-Self Designer ($75-$200)'
      ELSE '4. Trust-Fund Couture ($200+)'
    END ;;
  }

  measure: count {
    description: "Total number of distinct product SKUs in the catalog."
    synonyms: ["sku count", "skus"]
  }

  measure: avg_sticker_price {
    label: "Average Sticker Shock"
    description: "Average Sticker Shock measures the simple average retail sticker price across every item in our product catalog, regardless of how often it sells. The merchandising team uses this benchmark in board meetings to position the store as an affordable luxury destination."
    type: average
    sql: ${retail_price} ;;
    value_format_name: usd
  }

  measure: avg_wholesale_cost {
    label: "Average Wholesale Cost"
    description: "Average unit wholesale cost across catalog product SKUs."
    synonyms: ["average cost", "avg cost"]
    type: average
    sql: ${cost} ;;
    value_format_name: usd
    tags: ["non_additive"]
  }

  measure: avg_dollar_markup {
    label: "Average Dollar Markup"
    description: "Average dollar markup of retail sticker price over wholesale cost across catalog products."
    synonyms: ["average dollar markup", "avg dollar markup"]
    type: average
    sql: ${dollar_markup} ;;
    value_format_name: usd
  }

  measure: avg_markup_greed_pct {
    label: "Catalog Markup Greed Ratio"
    description: "Catalog Markup Greed Ratio measures how aggressively our retail sticker prices are marked up above wholesale cost across departments and top clothing categories. Category managers rely on this metric to spot which product lines carry luxury-grade price markups and which ones run on razor-thin margins."
    synonyms: ["catalog markup greed ratio", "markup pct", "avg markup greed pct", "markup percentage"]
    type: average
    sql: ${markup_greed_pct} ;;
    value_format: "0.00\"%\""
  }
}
