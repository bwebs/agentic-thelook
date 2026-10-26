include: "/bronze/explores/products_base.explore.lkml"

view: category_sku_price_facts {
  label: "Category Price Outlier Facts"

  derived_table: {
    explore_source: products_base {
      column: product_id { field: products.id }
      column: category { field: products.category }
      column: retail_price { field: products.retail_price }
      derived_column: cat_avg_price {
        sql: AVG(retail_price) OVER (PARTITION BY category) ;;
      }
      derived_column: cat_std_price {
        sql: STDDEV(retail_price) OVER (PARTITION BY category) ;;
      }
      derived_column: cat_price_z {
        sql: SAFE_DIVIDE(
          retail_price - AVG(retail_price) OVER (PARTITION BY category),
          STDDEV(retail_price) OVER (PARTITION BY category)
        ) ;;
      }
    }
  }

  dimension: product_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: category_avg_retail_price {
    label: "Category Average Retail Price"
    group_label: "Category Price Outlier Analysis"
    description: "Mean retail sticker price across all catalog SKUs within the item's clothing category."
    synonyms: ["cat avg price", "category mean retail price", "aisle average price"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.cat_avg_price ;;
  }

  dimension: category_stddev_retail_price {
    label: "Category Retail Price Standard Deviation"
    group_label: "Category Price Outlier Analysis"
    description: "Sample standard deviation of retail sticker prices across all catalog SKUs within the item's clothing category."
    synonyms: ["cat std price", "category price spread", "category price stddev"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.cat_std_price ;;
  }

  dimension: category_price_z_score {
    label: "Category Price Z-Score"
    group_label: "Category Price Outlier Analysis"
    description: "Standardized Z-score measuring how many within-category standard deviations the SKU's retail price sits above or below its category average."
    synonyms: ["cat price z", "price z-score", "category price z"]
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.cat_price_z ;;
  }

  dimension: category_price_outlier_term {
    label: "Category Price Outlier Taxonomy"
    group_label: "Category Price Outlier Analysis"
    description: "Category Price Outlier Taxonomy compares every product's retail price against the average and spread of prices inside its own clothing category, labeling items as Suspiciously Cheap Anomalies (Z < -1.0), Fair-Market Category Core (-1.0 to +1.0), Upper-Crust Category Premiums (+1.0 to +2.5), or Overpriced Category Unicorns (Z >= +2.5). Catalog pricing managers use this outlier tag to audit extreme high-priced items and verify they are priced accurately for their aisle."
    synonyms: [
      "category price outlier term",
      "category price outlier taxonomy",
      "price outlier tier",
      "category unicorn taxonomy"
    ]
    case: {
      when: {
        sql: ${category_price_z_score} < -1.0 ;;
        label: "Suspiciously Cheap Anomaly (Z < -1.0)"
      }
      when: {
        sql: ${category_price_z_score} <= 1.0 ;;
        label: "Fair-Market Category Core (-1.0 to +1.0)"
      }
      when: {
        sql: ${category_price_z_score} < 2.5 ;;
        label: "Upper-Crust Category Premium (+1.0 to +2.5)"
      }
      else: "Overpriced Category Unicorn (Z >= +2.5)"
    }
  }

  measure: avg_category_price_z_score {
    label: "Average Category Price Z-Score"
    description: "Mean within-category retail price Z-score across selected catalog SKUs."
    synonyms: ["avg z score", "average z-score", "mean category z-score"]
    type: average
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ${category_price_z_score} ;;
  }
}
