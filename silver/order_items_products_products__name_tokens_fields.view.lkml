view: order_items_products_products__name_tokens_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(COALESCE(${order_items.id}, 0) AS STRING), '_', CAST(${products.id} AS STRING), '_', CAST(${products__name_tokens.word_offset} AS STRING)) ;;
  }

  measure: token_weighted_units_sold {
    label: "Token-Weighted Units Sold"
    description: "Count of ordered line-item and title-word token pairs (weighting multi-occurrence words in the same title across sold units)."
    synonyms: ["buzzword units sold", "token weighted units sold"]
    type: count
    filters: [order_items.id: "NOT NULL"]
  }

  measure: total_token_weighted_revenue {
    label: "Buzzword-Attributed Revenue"
    description: "Gross dollar sales attributed across unnested product title keywords and ordered line items."
    synonyms: ["buzzword attributed revenue", "total token weighted revenue", "keyword attributed revenue"]
    tags: ["non_additive"]
    type: number
    sql: COALESCE(SUM(${order_items.sale_price}), 0) ;;
    value_format_name: usd
  }

  measure: avg_item_weighted_word_offset {
    label: "Average Sales-Weighted Word Position in Title"
    description: "Mean zero-based word position of a product title keyword weighted across ordered line items."
    synonyms: ["avg sales weighted word position", "item weighted word offset"]
    tags: ["non_additive"]
    type: average
    sql: ${products__name_tokens.word_offset} ;;
    value_format_name: decimal_2
  }
}
