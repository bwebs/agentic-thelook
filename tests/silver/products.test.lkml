include: "../../silver/explores/products.explore.lkml"

test: products_2024_01_01_order_items_join_metrics {
  explore_source: products {
    column: sku_count { field: products.count }
    column: units_sold { field: order_items.count }
    column: total_revenue { field: order_items.total_revenue }
    filters: {
      field: order_items.created_date
      value: "2024-01-01"
    }
  }
  assert: products_and_units_match {
    expression: ${products.count} = 55 AND ${order_items.count} = 55 ;;
  }
  assert: revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 2995.96 ;;
  }
}

test: products_id_le_1000_sku_velocity_invariants {
  explore_source: products {
    column: sku_velocity_tier { field: product_sales_facts.sku_velocity_tier }
    column: sku_count { field: products.count }
    column: units_sold { field: order_items.count }
    column: total_revenue { field: order_items.total_revenue }
    filters: {
      field: products.id
      value: "<=1000"
    }
    sorts: [product_sales_facts.sku_velocity_tier: asc]
  }
  assert: catalog_slice_partitions_all_1000_skus {
    expression: sum(${products.count}) = 1000 ;;
  }
  assert: hero_and_steady_mover_velocity_bounds_hold {
    expression: index(${product_sales_facts.sku_velocity_tier}, 1) = "Viral Hero SKU (5+ Units Sold)" AND index(${order_items.count}, 1) >= 5 * index(${products.count}, 1) AND index(${product_sales_facts.sku_velocity_tier}, 2) = "Steady Mover (2-4 Units Sold)" AND index(${order_items.count}, 2) >= 2 * index(${products.count}, 2) AND index(${order_items.count}, 2) <= 4 * index(${products.count}, 2) ;;
  }
  assert: single_sale_and_wallflower_bounds_hold {
    expression: index(${product_sales_facts.sku_velocity_tier}, 3) = "Lonely Single-Sale SKU (1 Unit Sold)" AND index(${order_items.count}, 3) = index(${products.count}, 3) AND index(${product_sales_facts.sku_velocity_tier}, 4) = "Unloved Zero-Sale Wallflower (0 Sold)" AND index(${order_items.count}, 4) = 0 AND index(${order_items.total_revenue}, 4) = 0 ;;
  }
}

test: products_2024_01_01_activity_weighted_retail_price {
  explore_source: products {
    column: avg_activity_weighted_retail_price { field: order_items_products_fields.avg_activity_weighted_retail_price }
    filters: [
      order_items.created_date: "2024-01-01",
      products.id: "NOT NULL"
    ]
  }
  assert: avg_activity_weighted_retail_price_matches {
    expression: round(${order_items_products_fields.avg_activity_weighted_retail_price}, 2) = 54.47 ;;
  }
}

test: products_id_le_5000_brand_prestige_invariants {
  explore_source: products {
    column: brand_prestige_tier { field: brand_facts.brand_prestige_tier }
    column: distinct_brands { field: products.distinct_brands }
    column: sku_count { field: products.count }
    filters: [
      products.id: "<=5000",
      products.brand: "-NULL"
    ]
  }
  assert: brand_prestige_tier_populated_and_bounded {
    expression: NOT is_null(${brand_facts.brand_prestige_tier})
      AND ${products.distinct_brands} > 0
      AND ${products.count} >= ${products.distinct_brands} ;;
  }
}

test: products_id_le_1000_brand_lineup_roles {
  explore_source: products {
    column: brand_lineup_strategic_role { field: brand_sku_facts.brand_lineup_strategic_role }
    column: sku_count { field: products.count }
    column: total_units_sold { field: product_sales_facts.total_units_sold }
    column: total_sku_revenue { field: product_sales_facts.total_sku_revenue }
    column: total_sku_profit { field: product_sales_facts.total_sku_profit }
    filters: {
      field: products.id
      value: "<=1000"
    }
    filters: {
      field: products.brand
      value: "-NULL"
    }
    sorts: [brand_sku_facts.brand_lineup_strategic_role: asc]
  }
  assert: strategic_role_populated {
    expression: NOT is_null(${brand_sku_facts.brand_lineup_strategic_role}) ;;
  }
  assert: sku_count_positive {
    expression: ${products.count} > 0 ;;
  }
  assert: lineup_metrics_consistent {
    expression: ${product_sales_facts.total_units_sold} >= 0 AND ${product_sales_facts.total_sku_revenue} >= ${product_sales_facts.total_sku_profit} ;;
  }
}

test: products_jeans_outliers_and_inventory_invariants {
  explore_source: products {
    column: sku_count { field: products.count }
    column: warehouse_count { field: distribution_centers.count }
    column: avg_category_price_z_score { field: category_sku_price_facts.avg_category_price_z_score }
    column: total_unsold_available_units { field: product_inventory_facts.total_unsold_available_units }
    column: total_sold_units { field: product_inventory_facts.total_sold_units }
    column: total_unsold_capital_value { field: product_inventory_facts.total_unsold_capital_value }
    filters: {
      field: products.category
      value: "Jeans"
    }
    filters: {
      field: distribution_centers.id
      value: "NOT NULL"
    }
    filters: {
      field: category_sku_price_facts.category_price_outlier_term
      value: "-EMPTY"
    }
    filters: {
      field: product_inventory_facts.replenishment_urgency_tier
      value: "-EMPTY"
    }
  }
  assert: jeans_z_score_mean_is_zero {
    expression: round(${category_sku_price_facts.avg_category_price_z_score}, 4) = 0 ;;
  }
  assert: jeans_warehouses_matches {
    expression: ${distribution_centers.count} = 10 ;;
  }
  assert: jeans_sku_count_positive {
    expression: ${products.count} >= 1000 ;;
  }
  assert: unsold_units_non_negative {
    expression: ${product_inventory_facts.total_unsold_available_units} >= 0 ;;
  }
  assert: sold_units_positive {
    expression: ${product_inventory_facts.total_sold_units} >= 1 ;;
  }
  assert: unsold_capital_non_negative {
    expression: ${product_inventory_facts.total_unsold_capital_value} >= 0 ;;
  }
}

test: products_2024_01_01_title_buzzword_revenue {
  explore_source: products {
    column: count { field: products.count }
    column: token_weighted_units_sold { field: order_items_products_products__name_tokens_fields.token_weighted_units_sold }
    column: total_token_weighted_revenue { field: order_items_products_products__name_tokens_fields.total_token_weighted_revenue }
    column: avg_item_weighted_word_offset { field: order_items_products_products__name_tokens_fields.avg_item_weighted_word_offset }
    filters: [
      order_items.created_date: "2024-01-01",
      order_items.status: "Complete",
      products__name_tokens.token_length: ">=4"
    ]
  }
  assert: token_weighted_units_matches {
    expression: ${order_items_products_products__name_tokens_fields.token_weighted_units_sold} = 112 ;;
  }
  assert: total_token_weighted_revenue_matches {
    expression: round(${order_items_products_products__name_tokens_fields.total_token_weighted_revenue}, 2) = 7484.97 ;;
  }
  assert: avg_item_weighted_word_offset_matches {
    expression: round(${order_items_products_products__name_tokens_fields.avg_item_weighted_word_offset}, 2) = 3.14 ;;
  }
}
