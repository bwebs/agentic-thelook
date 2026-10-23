include: "../../bronze/explores/products.explore.lkml"

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
