include: "../../bronze/inventory_items.view.lkml"
include: "../../bronze/inventory_items.refinement.lkml"

explore: inventory_items {
  label: "Inventory Items"
  view_name: inventory_items

  query: sunk_dusty_shelf_cost {
    description: "Unsold Dusty Shelf Inventory Cost adds up the total wholesale cash currently tied up in physical stock sitting unsold on warehouse shelves, alongside what that stock would fetch at full retail price. Finance reviews this number every Friday afternoon to push the procurement and clearance teams to move stagnant merchandise."
    measures: [inventory_items.count, inventory_items.sunk_dusty_shelf_cost, inventory_items.hypothetical_retail_value]
    filters: [inventory_items.sold_date: "NULL"]
  }
}
