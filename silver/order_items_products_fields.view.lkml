view: order_items_products_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${products.id} AS STRING), '_', CAST(COALESCE(${order_items.id}, 0) AS STRING)) ;;
  }

  measure: avg_activity_weighted_retail_price {
    label: "Average Activity-Weighted Retail Price"
    description: "Mean product retail sticker price across joined product and order-item rows (weights multi-sale SKUs by item count and unsold SKUs once)."
    type: average
    tags: ["non_additive"]
    sql: ${products.retail_price} ;;
    value_format_name: usd
  }

  measure: sock_units_sold {
    label: "Socks & Hosiery Units Sold"
    description: "Total order line item units sold across products in the 'Socks' and 'Socks & Hosiery' categories."
    synonyms: ["sock units sold", "socks and hosiery units sold"]
    type: count
    filters: [products.category: "Socks,Socks & Hosiery"]
  }

  measure: sock_unit_share {
    label: "Socks & Hosiery Unit Share"
    description: "Socks and Hosiery Obsession Index (Unit Share) calculates the share of all units sold that comes specifically from customers buying socks and hosiery across men's and women's lines."
    synonyms: ["sock unit share pct", "socks and hosiery obsession index", "socks unit share"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${sock_units_sold} / NULLIF(${order_items.count}, 0) ;;
    value_format_name: percent_2
  }

  measure: total_sock_revenue {
    label: "Total Socks & Hosiery Revenue"
    description: "Gross dollar sales from order line items in the 'Socks' and 'Socks & Hosiery' product categories."
    synonyms: ["total sock revenue", "sock revenue", "socks and hosiery revenue"]
    type: sum
    sql: ${order_items.sale_price} ;;
    filters: [products.category: "Socks,Socks & Hosiery"]
    value_format_name: usd
  }

  measure: sock_revenue_share {
    label: "Socks & Hosiery Revenue Share"
    description: "Share of total store gross revenue generated specifically from customers buying socks and hosiery across men's and women's lines."
    synonyms: ["sock revenue share", "sock revenue pct", "socks and hosiery revenue share"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${total_sock_revenue} / NULLIF(${order_items.total_revenue}, 0) ;;
    value_format_name: percent_2
  }

  measure: total_warm_clothing_revenue {
    label: "Cozy Warm Clothing Spend"
    description: "Gross dollar sales from warm cold-weather clothing categories ('Sweaters', 'Fashion Hoodies & Sweatshirts', 'Blazers & Jackets', and 'Outerwear & Coats')."
    synonyms: ["cozy warm clothing spend", "warm clothing spend", "cold-weather outerwear spend"]
    type: sum
    sql: ${order_items.sale_price} ;;
    filters: [products.category: "Sweaters,Fashion Hoodies & Sweatshirts,Blazers & Jackets,Outerwear & Coats"]
    value_format_name: usd
  }

  measure: warm_clothing_revenue_share {
    label: "Warm Clothing Spend Share"
    description: "Hemisphere and Latitude Fashion Chill Factor calculates the share of total clothing spend going toward warm sweaters, hoodies, jackets, and coats. Seasonal marketing teams use this geographic climate split to target cold-weather outerwear ads to northern shoppers while keeping warm-weather gear aimed at the tropics."
    synonyms: ["cozy spend share", "cozy spend share pct", "hemisphere and latitude fashion chill factor", "fashion chill factor"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${total_warm_clothing_revenue} / NULLIF(${order_items.total_revenue}, 0) ;;
    value_format_name: percent_2
  }

  measure: activewear_units {
    label: "Activewear Units Sold"
    description: "Total order line item units sold in the 'Active' product category."
    synonyms: ["activewear units", "active category units"]
    type: count
    filters: [products.category: "Active"]
  }

  measure: swimwear_units {
    label: "Swimwear Units Sold"
    description: "Total order line item units sold in the 'Swim' product category."
    synonyms: ["swimwear units", "swim category units"]
    type: count
    filters: [products.category: "Swim"]
  }

  measure: winter_cozy_units {
    label: "Sweaters & Outerwear Units Sold"
    description: "Total order line item units sold across the 'Sweaters' and 'Outerwear & Coats' winter categories."
    synonyms: ["winter cozy units", "sweater and coat units", "winter outerwear units"]
    type: count
    filters: [products.category: "Sweaters,Outerwear & Coats"]
  }

  measure: mens_units {
    label: "Menswear Units Sold"
    description: "Total order line item units sold in the 'Men' product department."
    synonyms: ["mens items", "mens units", "menswear items"]
    type: count
    filters: [products.department: "Men"]
  }

  measure: womens_units {
    label: "Womenswear Units Sold"
    description: "Total order line item units sold in the 'Women' product department."
    synonyms: ["womens items", "womens units", "womenswear items"]
    type: count
    filters: [products.department: "Women"]
  }

  measure: ordered_item_categories {
    label: "Ordered Item Categories List"
    description: "Comma-separated alphabetical list of clothing categories across all ordered line items in the basket or grouping (repeating duplicate categories)."
    synonyms: ["full item categories", "basket item categories", "ordered categories list"]
    tags: ["non_additive"]
    type: string
    sql: STRING_AGG(${products.category}, ', ' ORDER BY ${products.category}) ;;
  }

  measure: total_luxury_150plus_revenue {
    label: "Luxury High-Ticket Spend ($150+ Retail)"
    description: "Gross dollar sales from ordered line items whose catalog retail sticker price is $150 or more (products.retail_price >= 150)."
    synonyms: ["luxury 150plus spend", "high-ticket spend", "luxury item spend", "150 plus luxury revenue"]
    type: sum
    sql: ${order_items.sale_price} ;;
    filters: [products.retail_price: ">=150"]
    value_format_name: usd
  }

  measure: luxury_spend_share {
    label: "Midlife Crisis Luxury Splurge Share ($150+ Retail)"
    description: "Midlife Crisis Luxury Splurge Multiplier share of total gross clothing spend going toward high-ticket catalog items priced at $150 or more (total_luxury_150plus_revenue / total_revenue)."
    synonyms: ["luxury spend share", "luxury spend share pct", "midlife crisis luxury splurge multiplier", "high-ticket spend share"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${total_luxury_150plus_revenue} / NULLIF(${order_items.total_revenue}, 0) ;;
    value_format_name: percent_2
  }

  dimension: sale_price_per_title_word {
    hidden: yes
    type: number
    sql: ${order_items.sale_price} / NULLIF(${products.title_word_count}, 0) ;;
  }

  measure: avg_price_per_title_word {
    label: "Average Sale Price per Title Word"
    description: "Product Naming Verbosity Tax benchmark: mean item sale price divided by product title word count across ordered line items."
    synonyms: ["revenue per title word", "avg price per title word", "product naming verbosity tax"]
    tags: ["non_additive"]
    type: average
    sql: ${sale_price_per_title_word} ;;
    value_format_name: usd
  }

  measure: title_word_count_price_correlation {
    label: "Title Word Count-Price Correlation"
    description: "Pearson correlation coefficient between product title word count and ordered item sale price."
    synonyms: ["word count to price corr", "title word count price correlation"]
    tags: ["non_additive"]
    type: number
    sql: CORR(${products.title_word_count}, ${order_items.sale_price}) ;;
    value_format_name: decimal_4
  }

  measure: title_char_length_price_correlation {
    label: "Title Character Length-Price Correlation"
    description: "Pearson correlation coefficient between product title character length and ordered item sale price."
    synonyms: ["char length to price corr", "title character length price correlation"]
    tags: ["non_additive"]
    type: number
    sql: CORR(${products.title_char_length}, ${order_items.sale_price}) ;;
    value_format_name: decimal_4
  }

  measure: avg_units_sold_per_brand {
    label: "Average Units Sold per Catalog Brand"
    description: "Average number of order line items sold per distinct catalog brand (order_items.count / products.distinct_brands)."
    synonyms: ["avg units sold per brand", "units sold per brand"]
    tags: ["non_additive"]
    type: number
    value_format_name: decimal_2
    sql: 1.0 * ${order_items.count} / NULLIF(${products.distinct_brands}, 0) ;;
  }
}
