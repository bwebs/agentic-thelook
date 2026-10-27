include: "/silver/explores/products_sales_base.explore.lkml"

view: category_sales_facts {
  label: "Category Sold Price & Order Reach Facts"

  derived_table: {
    explore_source: products_sales_base {
      column: category { field: products.category }
      column: cat_mean_price { field: order_items.avg_item_price }
      column: cat_std_price { field: order_items.stddev_sale_price }
      column: cat_order_cnt { field: order_items.distinct_orders }
      filters: [
        order_items.id: "NOT NULL",
        products.category: "-NULL"
      ]
    }
  }

  dimension: category {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cat_mean_price {
    label: "Category Mean Sold Price"
    group_label: "Fashion Guilt Price-Outlier Analysis"
    description: "Average sale price across all ordered items within the product's clothing category."
    synonyms: ["cat mean price", "category baseline price", "category normal sold price"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.cat_mean_price ;;
  }

  dimension: cat_std_price {
    label: "Category Sold Price Standard Deviation"
    group_label: "Fashion Guilt Price-Outlier Analysis"
    description: "Sample standard deviation of sale prices across all ordered items within the product's clothing category."
    synonyms: ["cat std price", "category sold price spread"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.cat_std_price ;;
  }

  dimension: _cat_order_cnt {
    hidden: yes
    type: number
    sql: ${TABLE}.cat_order_cnt ;;
  }

  measure: category_orders {
    label: "Category Distinct Orders"
    description: "Total distinct customer orders containing at least one item from this clothing category across the store."
    synonyms: ["cat order count", "category order reach", "orders with category"]
    tags: ["non_additive"]
    type: max
    sql: ${_cat_order_cnt} ;;
  }
}
