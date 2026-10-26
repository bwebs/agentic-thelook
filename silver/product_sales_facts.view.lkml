include: "/silver/explores/order_items.explore.lkml"

view: product_sales_facts {
  label: "Product Sales Velocity Facts"

  derived_table: {
    explore_source: order_items {
      column: product_id { field: order_items.product_id }
      column: units_sold { field: order_items.count }
      column: sku_revenue { field: order_items.total_revenue }
      column: sku_profit { field: inventory_items_order_items_fields.total_gross_profit }
      filters: [order_items.product_id: "NOT NULL"]
    }
  }

  dimension: product_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: units_sold {
    label: "Historical Units Sold"
    description: "Cumulative lifetime order item units sold for the catalog product SKU (0 for unsold SKUs)."
    synonyms: ["sku units sold", "lifetime units sold"]
    type: number
    sql: COALESCE(${TABLE}.units_sold, 0) ;;
  }

  dimension: sku_revenue {
    label: "SKU Lifetime Revenue"
    description: "Cumulative lifetime gross dollar sales for the catalog product SKU (0 for unsold SKUs)."
    synonyms: ["sku revenue", "product lifetime revenue"]
    type: number
    value_format_name: usd
    sql: COALESCE(${TABLE}.sku_revenue, 0) ;;
  }

  dimension: sku_profit {
    label: "SKU Lifetime Gross Profit"
    description: "Cumulative lifetime gross dollar profit (sale_price minus inventory cost) for the catalog product SKU (0 for unsold SKUs)."
    synonyms: ["sku profit", "product lifetime profit"]
    type: number
    value_format_name: usd
    sql: COALESCE(${TABLE}.sku_profit, 0) ;;
  }

  dimension: sku_velocity_tier {
    label: "Bestseller Hero versus Zero-Sale Wallflower"
    description: "Bestseller Hero versus Zero-Sale Wallflower classifies every product in our catalog by its historical sales volume into 'Viral Hero SKU (5+ Units Sold)', 'Steady Mover (2-4 Units Sold)', 'Lonely Single-Sale SKU (1 Unit Sold)', and 'Unloved Zero-Sale Wallflower (0 Sold)'. Merchandising planners use this velocity tier to prune dead catalog items and keep hero products well stocked before major sales events."
    synonyms: ["sku velocity tier", "bestseller hero vs zero-sale wallflower", "product velocity tier", "catalog sales velocity tier"]
    case: {
      when: {
        sql: ${units_sold} >= 5 ;;
        label: "Viral Hero SKU (5+ Units Sold)"
      }
      when: {
        sql: ${units_sold} BETWEEN 2 AND 4 ;;
        label: "Steady Mover (2-4 Units Sold)"
      }
      when: {
        sql: ${units_sold} = 1 ;;
        label: "Lonely Single-Sale SKU (1 Unit Sold)"
      }
      else: "Unloved Zero-Sale Wallflower (0 Sold)"
    }
  }

  measure: total_units_sold {
    label: "Total Catalog SKU Units Sold"
    description: "Total lifetime units sold summed across catalog product SKUs."
    synonyms: ["total sku units sold", "lineup units sold"]
    type: sum
    sql: ${units_sold} ;;
  }

  measure: total_sku_revenue {
    label: "Total Catalog SKU Revenue"
    description: "Total lifetime gross revenue summed across catalog product SKUs."
    synonyms: ["total sku revenue", "lineup total revenue"]
    type: sum
    value_format_name: usd
    sql: ${sku_revenue} ;;
  }

  measure: total_sku_profit {
    label: "Total Catalog SKU Gross Profit"
    description: "Total lifetime gross dollar profit summed across catalog product SKUs."
    synonyms: ["total sku profit", "lineup total profit"]
    type: sum
    value_format_name: usd
    sql: ${sku_profit} ;;
  }
}
