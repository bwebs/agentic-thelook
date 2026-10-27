include: "/silver/explores/inventory_items.explore.lkml"

view: warehouse_inventory_facts {
  label: "Warehouse Inventory Ledger Facts"

  derived_table: {
    explore_source: inventory_items {
      column: dc_id { field: inventory_items.product_distribution_center_id }
      column: total_units_stocked { field: inventory_items.count }
      column: distinct_skus_stocked { field: inventory_items.distinct_products }
      column: total_capital_deployed { field: inventory_items.total_cost }
      column: dead_stock_capital_drag { field: inventory_items.sunk_dusty_shelf_cost }
      column: avg_inventory_turn_days { field: inventory_items.avg_inventory_turn_days }
      filters: [inventory_items.product_distribution_center_id: "NOT NULL"]
    }
  }

  dimension: dc_id {
    primary_key: yes
    label: "Stocked Warehouse ID"
    description: "Unique distribution center identifier for stocked fulfillment warehouses."
    type: number
    sql: ${TABLE}.dc_id ;;
  }

  dimension: total_units_stocked {
    label: "Warehouse Units Stocked"
    description: "Total physical inventory units stocked in the distribution center."
    type: number
    sql: ${TABLE}.total_units_stocked ;;
  }

  dimension: distinct_skus_stocked {
    label: "Warehouse Distinct SKUs Stocked"
    description: "Count of distinct catalog product SKUs stocked in the distribution center."
    synonyms: ["distinct skus stocked"]
    type: number
    sql: ${TABLE}.distinct_skus_stocked ;;
  }

  dimension: total_capital_deployed {
    label: "Warehouse Capital Deployed"
    description: "Total wholesale inventory capital deployed in the distribution center."
    synonyms: ["capital deployed"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.total_capital_deployed ;;
  }

  dimension: dead_stock_capital_drag {
    label: "Warehouse Dead-Stock Capital Drag"
    description: "Wholesale inventory capital currently tied up in unsold units sitting in the distribution center."
    synonyms: ["dead stock drag", "dead stock capital drag"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.dead_stock_capital_drag ;;
  }

  dimension: avg_inventory_turn_days {
    label: "Warehouse Average Inventory Turn Days"
    description: "Mean fractional days (hours / 24.0) sold units sat on the shelf in the distribution center."
    synonyms: ["avg turn days"]
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.avg_inventory_turn_days ;;
  }

  measure: count {
    label: "Stocked Warehouses"
    description: "Number of distribution centers with stocked inventory."
    type: count
    filters: [dc_id: "NOT NULL"]
  }

  measure: total_distinct_skus_stocked {
    label: "Distinct SKUs Stocked"
    description: "Stocked SKU count across warehouse inventory ledgers."
    synonyms: ["distinct skus stocked"]
    type: sum
    sql: ${distinct_skus_stocked} ;;
  }

  measure: total_warehouse_capital_deployed {
    label: "Capital Deployed"
    description: "Total wholesale capital deployed across warehouse inventory ledgers."
    synonyms: ["capital deployed", "total capital deployed"]
    type: sum
    value_format_name: usd
    sql: ${total_capital_deployed} ;;
  }

  measure: total_dead_stock_drag {
    label: "Dead-Stock Capital Drag"
    description: "Total wholesale capital tied up in unsold goods across warehouse inventory ledgers."
    synonyms: ["dead stock drag", "dead stock capital drag"]
    type: sum
    value_format_name: usd
    sql: ${dead_stock_capital_drag} ;;
  }

  measure: avg_warehouse_turn_days {
    label: "Average Warehouse Turn Days"
    description: "Mean warehouse inventory turn days across evaluated fulfillment centers."
    synonyms: ["avg turn days", "avg inventory turn days"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_1
    sql: ${avg_inventory_turn_days} ;;
  }
}
