include: "inventory_items.view.lkml"

view: +inventory_items {
  measure: count {
    label: "Inventory Units Count"
    description: "Total count of physical inventory units (filter by Sold Date is null for unsold units on shelf)."
  }

  measure: total_cost {
    hidden: yes
    type: sum
    sql: ${cost} ;;
    value_format_name: usd
  }

  measure: sunk_dusty_shelf_cost {
    label: "Unsold Dusty Shelf Inventory Cost"
    description: "Unsold Dusty Shelf Inventory Cost adds up the total wholesale cash currently tied up in physical stock sitting unsold on warehouse shelves, alongside what that stock would fetch at full retail price. Finance reviews this number every Friday afternoon to push the procurement and clearance teams to move stagnant merchandise."
    type: number
    sql: ROUND(${total_cost}, 2) ;;
    value_format_name: usd
  }

  measure: total_product_retail_price {
    hidden: yes
    type: sum
    sql: ${product_retail_price} ;;
    value_format_name: usd
  }

  measure: hypothetical_retail_value {
    label: "Hypothetical Retail Value"
    description: "Total full retail sticker value of physical inventory stock."
    type: number
    sql: ROUND(${total_product_retail_price}, 2) ;;
    value_format_name: usd
  }
}
