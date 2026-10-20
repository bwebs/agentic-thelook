include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"

explore: order_items {
  label: "Order Items"
  view_name: order_items

  query: total_revenue {
    description: "Overall gross dollar sales across every item ever ordered in the store, before backing out returns, cancellations, or product cost."
    measures: [order_items.total_revenue]
  }
}
