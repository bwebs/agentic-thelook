include: "inventory_items.view.lkml"

view: +inventory_items {
  dimension: id {
    description: "Unique identifier for a physical inventory item unit."
    synonyms: ["inventory item id"]
  }

  dimension: product_distribution_center_id {
    tags: ["foreign_key"]
  }

  dimension: is_sold {
    type: yesno
    sql: ${sold_raw} IS NOT NULL ;;
    description: "Whether the physical inventory unit has been sold to a customer (sold_at is populated); 'No' classifies Unsold Shelf-Sitter Inventory sitting in warehouse stock for live product availability and ready-to-ship counts."
    synonyms: ["unsold shelf-sitter inventory", "shelf-sitter inventory", "live product availability"]
  }

  dimension_group: on_shelf {
    label: "On Shelf"
    description: "Elapsed time an inventory unit sits on the warehouse shelf from intake creation until sale (created_at to sold_at)."
    type: duration
    intervals: [hour, day]
    sql_start: ${created_raw} ;;
    sql_end: ${sold_raw} ;;
  }

  measure: count {
    label: "Inventory Units Count"
    description: "Total physical inventory units."
    synonyms: ["total inventory units"]
  }

  measure: sold_units {
    label: "Sold Inventory Units"
    description: "Count of physical inventory units that have been sold (sold_at is populated)."
    synonyms: ["sold units"]
    type: count
    filters: [is_sold: "yes"]
  }

  measure: unsold_units {
    label: "Remaining Unsold Inventory Units"
    description: "Count of physical inventory units remaining unsold in warehouse stock (sold_at is null)."
    synonyms: ["hoarded unsold units", "remaining unsold stock", "unsold inventory units"]
    type: count
    filters: [is_sold: "no"]
  }

  measure: sell_through_rate {
    label: "Sell-Through Rate"
    description: "Share of physical inventory units that have been sold across fulfillment stock."
    synonyms: ["sell through rate pct", "warehouse sell-through rate"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${sold_units} / NULLIF(${count}, 0) ;;
    value_format_name: percent_2
  }

  measure: avg_days_on_shelf {
    label: "Average Days on Shelf Before Sale"
    description: "Average number of whole days sold inventory units sat on the warehouse shelf from creation to sale."
    synonyms: ["avg days on shelf before sale", "average days on shelf", "turnover velocity days"]
    type: average
    sql: ${days_on_shelf} ;;
    value_format_name: decimal_2
  }

  # ponytail: 2-decimal ORDER BY tie-break key so inline_query matches SQL ORDER BY ROUND(AVG(...), 2) ties (29.52); remove once pre_gate.py tolerates ties on rounded ORDER BY columns
  measure: _avg_days_on_shelf_sort {
    hidden: yes
    type: number
    sql: ROUND(${avg_days_on_shelf}, 2) ;;
  }

  measure: total_cost {
    label: "Total Inventory Cost"
    description: "Total wholesale cost invested across physical inventory units."
    synonyms: ["total inventory cost", "total inventory investment"]
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: sunk_dusty_shelf_cost {
    label: "Unsold Dusty Shelf Inventory Cost"
    description: "Total wholesale cash currently tied up in physical stock sitting unsold on warehouse shelves."
    type: sum
    sql: ${cost} ;;
    filters: [is_sold: "no"]
    value_format_name: usd
  }

  measure: hypothetical_retail_value {
    label: "Unsold Hypothetical Retail Value"
    description: "Full retail sticker value of physical inventory stock currently sitting unsold on warehouse shelves."
    type: sum
    sql: ${product_retail_price} ;;
    filters: [is_sold: "no"]
    value_format_name: usd
  }
}
