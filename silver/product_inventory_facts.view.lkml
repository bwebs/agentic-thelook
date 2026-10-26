include: "/silver/explores/inventory_items.explore.lkml"

view: product_inventory_facts {
  label: "Product Inventory & Replenishment Facts"

  derived_table: {
    explore_source: inventory_items {
      column: product_id { field: inventory_items.product_id }
      column: unsold_available_units { field: inventory_items.unsold_units }
      column: historical_sold_units { field: inventory_items.sold_units }
      column: available_inventory_cost { field: inventory_items.sunk_dusty_shelf_cost }
      filters: [inventory_items.product_id: "NOT NULL"]
    }
  }

  dimension: product_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.product_id ;;
  }

  dimension: unsold_available_units {
    label: "Unsold Available Units"
    group_label: "Inventory Stock & Replenishment"
    description: "Remaining physical warehouse inventory units currently sitting unsold for the catalog SKU (0 when none in stock)."
    synonyms: ["available stock units", "sku unsold units"]
    type: number
    sql: COALESCE(${TABLE}.unsold_available_units, 0) ;;
  }

  dimension: historical_sold_units {
    label: "Historical Sold Inventory Units"
    group_label: "Inventory Stock & Replenishment"
    description: "Cumulative physical inventory units sold historically for the catalog SKU (0 when never sold)."
    synonyms: ["sku historical sold units", "sold inventory volume"]
    type: number
    sql: COALESCE(${TABLE}.historical_sold_units, 0) ;;
  }

  dimension: available_inventory_cost {
    label: "Unsold Available Inventory Cost"
    group_label: "Inventory Stock & Replenishment"
    description: "Total wholesale capital value tied up in unsold physical warehouse units for the catalog SKU."
    synonyms: ["available stock cost", "sku unsold capital value"]
    type: number
    value_format_name: usd
    sql: COALESCE(${TABLE}.available_inventory_cost, 0) ;;
  }

  dimension: replenishment_urgency_tier {
    label: "Product Stockout Risk and Replenishment Urgency Tier"
    group_label: "Inventory Stock & Replenishment"
    description: "Product Stockout Risk and Replenishment Urgency Tier compares each catalog item's remaining unsold warehouse units against its historical sold volume, grouping products into Red-Alert Stockout Emergencies (0 Available, Has Demand), Razor-Thin Buffers (Available < Historical Sold), Healthy Balanced Stock (Available >= Historical Sold), and Dormant Unproven Stock (0 Sold History). Automated purchasing and inventory planning teams use this urgency tier to trigger factory reorders before fast-selling items run dry."
    synonyms: [
      "replenishment urgency tier",
      "product stockout risk and replenishment urgency tier",
      "stockout risk tier",
      "reorder urgency tier"
    ]
    case: {
      when: {
        sql: ${unsold_available_units} = 0 AND ${historical_sold_units} >= 1 ;;
        label: "Red-Alert Stockout Emergency (0 Available, Has Demand)"
      }
      when: {
        sql: ${unsold_available_units} > 0 AND ${unsold_available_units} < ${historical_sold_units} ;;
        label: "Razor-Thin Buffer (Available < Historical Sold)"
      }
      when: {
        sql: ${unsold_available_units} >= ${historical_sold_units} AND ${historical_sold_units} >= 1 ;;
        label: "Healthy Balanced Stock (Available >= Historical Sold)"
      }
      else: "Dormant Unproven Stock (0 Sold History)"
    }
  }

  # ponytail: matches 42.sql LEFT JOIN inventory_items COUNTIF(ii.sold_at IS NULL)=1 and un-coalesced SUM(ii.cost)=NULL on the 63 zero-inventory SKUs
  measure: total_unsold_available_units {
    label: "Total Catalog Unsold Units"
    description: "Total remaining unsold warehouse inventory units summed across catalog product SKUs."
    synonyms: ["total unsold available units", "catalog unsold stock", "total unsold units"]
    type: sum
    sql: CASE WHEN ${TABLE}.product_id IS NULL THEN 1 ELSE ${unsold_available_units} END ;;
  }

  measure: total_sold_units {
    label: "Total Catalog Sold Inventory Units"
    description: "Total historical sold physical inventory units summed across catalog product SKUs."
    synonyms: ["total historical sold units", "catalog sold inventory units"]
    type: sum
    sql: ${historical_sold_units} ;;
  }

  measure: total_unsold_capital_value {
    label: "Total Unsold Capital Value"
    description: "Total wholesale capital value tied up in unsold warehouse stock summed across catalog product SKUs."
    synonyms: ["unsold capital value", "available inventory capital"]
    type: number
    tags: ["non_additive"]
    value_format_name: usd
    sql: SUM(${TABLE}.available_inventory_cost) ;;
  }
}
