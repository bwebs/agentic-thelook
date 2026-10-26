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
