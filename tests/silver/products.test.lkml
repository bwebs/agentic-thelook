include: "../../silver/explores/products.explore.lkml"

test: products_catalog_metrics_at_fixed_id {
  explore_source: products {
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
