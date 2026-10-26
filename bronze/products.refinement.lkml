include: "products.view.lkml"

view: +products {
  dimension: distribution_center_id {
    tags: ["foreign_key"]
  }

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

  dimension: gross_margin_tier {
    label: "Gross Margin Cash-Cow Tier"
    description: "Gross Margin Cash-Cow Tier classifies every product by combining its percentage gross margin and dollar profit per unit into four quadrants: 'Golden Goose Cash Cow ($40+ profit & 55%+ margin)', 'High-Margin Trinket (<$40 profit & 55%+ margin)', 'Big-Ticket Low-Margin Heavyweight ($40+ profit & <55% margin)', and 'Commodity Margin Grinder (<$40 profit & <55% margin)'. Paid advertising teams use this product classification so they never spend heavy ad budgets promoting low-dollar trinkets that cannot pay back the click cost."
    synonyms: ["gross margin cash-cow tier", "margin cash cow tier", "product margin quadrant", "gross margin tier"]
    case: {
      when: {
        sql: ${dollar_markup} >= 40.0 AND SAFE_DIVIDE(${dollar_markup}, ${retail_price}) >= 0.55 ;;
        label: "Golden Goose Cash Cow ($40+ profit & 55%+ margin)"
      }
      when: {
        sql: ${dollar_markup} < 40.0 AND SAFE_DIVIDE(${dollar_markup}, ${retail_price}) >= 0.55 ;;
        label: "High-Margin Trinket (<$40 profit & 55%+ margin)"
      }
      when: {
        sql: ${dollar_markup} >= 40.0 AND SAFE_DIVIDE(${dollar_markup}, ${retail_price}) < 0.55 ;;
        label: "Big-Ticket Low-Margin Heavyweight ($40+ profit & <55% margin)"
      }
      else: "Commodity Margin Grinder (<$40 profit & <55% margin)"
    }
  }

  dimension: wardrobe_anatomy_zone {
    label: "Wardrobe Anatomy Zone"
    description: "Wardrobe Anatomy Zone maps all twenty-six clothing categories onto the part of the human body they cover: 'Upper Torso, Outerwear & Accessories Zone', 'Lower Half & Legs Zone', 'Feet & Ankles Zone', 'Full-Body Ensemble Zone', and 'Unmentionables, Poolside & Pajama Zone'. Outfit recommendation tools use these anatomical zones to suggest a matching top, bottom, and pair of socks rather than recommending four pairs of pants."
    synonyms: ["wardrobe anatomy zone", "anatomical wardrobe zone", "body coverage zone", "outfit anatomy zone"]
    case: {
      when: {
        sql: ${category} IS NULL OR ${category} NOT IN ('Pants & Capris', 'Jeans', 'Shorts', 'Skirts', 'Leggings', 'Pants', 'Socks', 'Socks & Hosiery', 'Dresses', 'Suits', 'Suits & Sport Coats', 'Jumpsuits & Rompers', 'Swim', 'Intimates', 'Underwear', 'Sleep & Lounge') ;;
        label: "Upper Torso, Outerwear & Accessories Zone"
      }
      when: {
        sql: ${category} IN ('Pants & Capris', 'Jeans', 'Shorts', 'Skirts', 'Leggings', 'Pants') ;;
        label: "Lower Half & Legs Zone"
      }
      when: {
        sql: ${category} IN ('Socks', 'Socks & Hosiery') ;;
        label: "Feet & Ankles Zone"
      }
      when: {
        sql: ${category} IN ('Dresses', 'Suits', 'Suits & Sport Coats', 'Jumpsuits & Rompers') ;;
        label: "Full-Body Ensemble Zone"
      }
      else: "Unmentionables, Poolside & Pajama Zone"
    }
  }

  measure: count {
    description: "Total number of distinct product SKUs in the catalog."
    synonyms: ["sku count", "skus"]
  }

  measure: distinct_categories {
    label: "Distinct Categories"
    description: "Count of distinct clothing categories in the product catalog."
    synonyms: ["category count", "unique categories"]
    type: count_distinct
    sql: ${category} ;;
    tags: ["non_additive"]
  }

  measure: distinct_brands {
    label: "Distinct Brands"
    description: "Count of distinct brands in the product catalog."
    synonyms: ["brands count", "brand count", "unique brands"]
    type: count_distinct
    sql: ${brand} ;;
    tags: ["non_additive"]
  }

  measure: avg_sticker_price {
    label: "Average Sticker Shock"
    description: "Average Sticker Shock measures the simple average retail sticker price across every item in our product catalog, regardless of how often it sells. The merchandising team uses this benchmark in board meetings to position the store as an affordable luxury destination."
    type: average
    sql: ${retail_price} ;;
    value_format_name: usd
  }

  measure: min_retail_price {
    label: "Minimum Retail Price"
    description: "Minimum retail sticker price across catalog product SKUs."
    synonyms: ["min price", "min retail price", "lowest sticker price"]
    type: min
    sql: ${retail_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
  }

  measure: max_retail_price {
    label: "Maximum Retail Price"
    description: "Maximum retail sticker price across catalog product SKUs."
    synonyms: ["max price", "max retail price", "highest sticker price"]
    type: max
    sql: ${retail_price} ;;
    value_format_name: usd
    tags: ["non_additive"]
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
