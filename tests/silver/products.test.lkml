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
