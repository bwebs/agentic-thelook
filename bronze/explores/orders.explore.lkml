include: "../orders.view.lkml"
include: "../orders.refinement.lkml"

explore: orders {
  label: "Orders"
  view_name: orders
  hidden: no

  query: cart_stuffing_velocity {
    description: "Cart Stuffing Velocity measures the average, maximum, and spread of how many items customers pack into a single order."
    measures: [orders.avg_items_per_order, orders.max_items_per_order, orders.stddev_items_per_order]
  }

  query: order_volume_by_basket_size {
    description: "Full breakdown of order volume by basket size for setting minimum item thresholds for free shipping and bundle promotions."
    dimensions: [orders.num_of_item]
    measures: [orders.count]
    sorts: [orders.num_of_item: asc]
  }

  query: buyers_remorse_order_volume {
    description: "Buyer's Remorse Order Volume tracks how many orders end up cancelled or returned."
    measures: [orders.cancelled_or_returned_orders]
  }

  query: order_volume_and_items_by_status {
    description: "Breakdown of order count and total items involved across order fulfillment statuses."
    dimensions: [orders.status]
    measures: [orders.count, orders.total_items]
    sorts: [orders.count: desc]
  }

  query: mega_basket_bulk_orders {
    description: "Mega-Basket Bulk Order flags any single checkout where the customer packed three or more items into their order. Warehouse fulfillment teams use this tag to route multi-item purchases to larger box-packing stations."
    dimensions: [
      orders.order_id,
      orders.user_id,
      orders.num_of_item,
      orders.status,
      orders.created_timestamp
    ]
    filters: [orders.is_mega_basket_bulk_order: "yes"]
    sorts: [
      orders.num_of_item: desc,
      orders.created_timestamp: desc
    ]
    limit: 25
  }

  query: orders_by_circadian_chronotype {
    description: "Order count and total items ordered grouped by Circadian Shopping Chronotype (UTC hour-of-day shopper persona)."
    dimensions: [orders.circadian_chronotype]
    measures: [orders.count, orders.total_items]
    sorts: [orders.circadian_chronotype: asc]
  }
}
