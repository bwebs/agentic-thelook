include: "inventory_items.view.lkml"

view: +inventory_items {
  dimension: is_sold {
    type: yesno
    sql: ${sold_raw} IS NOT NULL ;;
    description: "Whether the inventory unit has been sold (sold_at is populated)."
  }

  measure: count {
    label: "Inventory Units Count"
    description: "Total physical inventory units."
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
