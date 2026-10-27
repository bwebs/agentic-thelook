include: "../../silver/explores/products.explore.lkml"

test: products_refinement_metrics {
  explore_source: products {
    column: avg_sticker_price { field: products.avg_sticker_price }
    column: avg_dollar_markup { field: products.avg_dollar_markup }
    column: avg_markup_greed_pct { field: products.avg_markup_greed_pct }
    column: product_count { field: products.count }
    filters: {
      field: products.id
      value: "1"
    }
  }
  assert: avg_sticker_price_matches {
    expression: round(${products.avg_sticker_price}, 2) = 49 ;;
  }
  assert: avg_dollar_markup_matches {
    expression: round(${products.avg_dollar_markup}, 2) = 21.95 ;;
  }
  assert: avg_markup_greed_pct_matches {
    expression: round(${products.avg_markup_greed_pct}, 2) = 81.16 ;;
  }
  assert: product_count_matches {
    expression: ${products.count} = 1 ;;
  }
}

test: products_id_le_1000_price_tier_metrics {
  explore_source: products {
    column: price_tier { field: products.price_tier }
    column: count { field: products.count }
    column: avg_wholesale_cost { field: products.avg_wholesale_cost }
    filters: {
      field: products.id
      value: "<=1000"
    }
    sorts: [products.price_tier: asc]
  }
  assert: impulse_tier_matches {
    expression: index(${products.price_tier}, 1) = "1. Impulse Pocket Change (<$25)" AND index(${products.count}, 1) = 350 AND round(index(${products.avg_wholesale_cost}, 1), 2) = 8.77 ;;
  }
  assert: staple_tier_matches {
    expression: index(${products.price_tier}, 2) = "2. Everyday Mall Staple ($25-$75)" AND index(${products.count}, 2) = 492 AND round(index(${products.avg_wholesale_cost}, 2), 2) = 22.67 ;;
  }
  assert: designer_tier_matches {
    expression: index(${products.price_tier}, 3) = "3. Treat-Yo-Self Designer ($75-$200)" AND index(${products.count}, 3) = 140 AND round(index(${products.avg_wholesale_cost}, 3), 2) = 54.80 ;;
  }
  assert: couture_tier_matches {
    expression: index(${products.price_tier}, 4) = "4. Trust-Fund Couture ($200+)" AND index(${products.count}, 4) = 18 AND round(index(${products.avg_wholesale_cost}, 4), 2) = 131.58 ;;
  }
}

test: products_id_le_1000_margin_and_anatomy_metrics {
  explore_source: products {
    column: gross_margin_tier { field: products.gross_margin_tier }
    column: wardrobe_anatomy_zone { field: products.wardrobe_anatomy_zone }
    column: count { field: products.count }
    column: distinct_categories { field: products.distinct_categories }
    column: min_retail_price { field: products.min_retail_price }
    column: max_retail_price { field: products.max_retail_price }
    filters: {
      field: products.id
      value: "<=1000"
    }
    sorts: [products.gross_margin_tier: asc, products.wardrobe_anatomy_zone: asc]
  }
  assert: golden_goose_tier_row_matches {
    expression: index(${products.gross_margin_tier}, 1) = "Golden Goose Cash Cow ($40+ profit & 55%+ margin)" AND index(${products.wardrobe_anatomy_zone}, 1) = "Upper Torso, Outerwear & Accessories Zone" AND index(${products.count}, 1) = 43 AND index(${products.distinct_categories}, 1) = 1 AND round(index(${products.min_retail_price}, 1), 2) = 74.99 AND round(index(${products.max_retail_price}, 1), 2) = 352 ;;
  }
  assert: commodity_grinder_tier_row_matches {
    expression: index(${products.gross_margin_tier}, 4) = "Commodity Margin Grinder (<$40 profit & <55% margin)" AND index(${products.count}, 4) = 797 AND index(${products.distinct_categories}, 4) = 2 AND round(index(${products.min_retail_price}, 4), 2) = 3.11 AND round(index(${products.max_retail_price}, 4), 2) = 92 ;;
  }
}

test: products_id_le_1000_distinct_brands {
  explore_source: products {
    column: distinct_brands { field: products.distinct_brands }
    filters: [products.id: "<=1000"]
  }
  assert: distinct_brands_matches {
    expression: ${products.distinct_brands} = 258 ;;
  }
}

test: products_id_500_title_verbosity_and_tokens {
  explore_source: products {
    column: count { field: products.count }
    column: max_title_word_count { field: products.max_title_word_count }
    column: token_count { field: products__name_tokens.count }
    column: avg_word_position_in_title { field: products__name_tokens.avg_word_position_in_title }
    filters: [
      products.id: "<=500",
      products__name_tokens.token_length: ">=4"
    ]
  }
  assert: max_title_word_count_matches {
    expression: ${products.max_title_word_count} = 20 ;;
  }
  assert: token_count_matches {
    expression: ${products__name_tokens.count} = 3601 ;;
  }
  assert: avg_word_position_matches {
    expression: round(${products__name_tokens.avg_word_position_in_title}, 2) = 4.13 ;;
  }
}
