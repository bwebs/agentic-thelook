include: "../../bronze/explores/products_base.explore.lkml"

test: products_base_refinement_metrics {
  explore_source: products_base {
    column: avg_sticker_price { field: products.avg_sticker_price }
    column: product_count { field: products.count }
    filters: {
      field: products.id
      value: "1"
    }
  }
  assert: avg_sticker_price_matches {
    expression: round(${products.avg_sticker_price}, 2) = 49 ;;
  }
  assert: product_count_matches {
    expression: ${products.count} = 1 ;;
  }
}
