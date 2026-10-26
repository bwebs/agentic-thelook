include: "../common_helpers.view.lkml"
include: "../inventory_items.view.lkml"
include: "../inventory_items.refinement.lkml"

explore: inventory_items_base {
  label: "Inventory Items"
  view_name: inventory_items
  hidden: yes
  cancel_grouping_fields: [common_helpers.no_group]

  join: common_helpers {
    sql: ;;
    relationship: one_to_one
  }

  query: unsold_dusty_shelf_inventory_cost {
    description: "Unsold Dusty Shelf Inventory Cost adds up the total wholesale cash currently tied up in physical stock sitting unsold on warehouse shelves, alongside what that stock would fetch at full retail price."
    measures: [
      inventory_items.count,
      inventory_items.sunk_dusty_shelf_cost,
      inventory_items.hypothetical_retail_value
    ]
    filters: [inventory_items.is_sold: "no"]
  }
}
