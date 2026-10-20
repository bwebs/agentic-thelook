include: "../order_items.view.lkml"
include: "../order_items.refinement.lkml"

explore: order_items_base {
  label: "Order Items (Base)"
  view_name: order_items
  hidden: yes
}
