include: "../inventory_items.view.lkml"
include: "../inventory_items.refinement.lkml"

explore: inventory_items_base {
  label: "Inventory Items (Base)"
  view_name: inventory_items
  hidden: yes
}
