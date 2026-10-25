include: "../order_items.view.lkml"
include: "../order_items.refinement.lkml"

explore: order_items {
  label: "Order Items"
  view_name: order_items
  hidden: no

  query: total_revenue {
    description: "Overall gross dollar sales across every item ever ordered in the store, before backing out returns, cancellations, or product cost."
    measures: [order_items.total_revenue]
  }

  query: total_line_items_sold {
    description: "Total Impulse Line Items Count tracks the sheer number of individual clothing items customers have tossed into their virtual carts and checked out. Warehouse operations use this volume metric to forecast daily packing workload and estimate how many shipping boxes they need to fold."
    measures: [order_items.count]
  }

  query: package_procrastination_index {
    description: "Package Procrastination Index tracks how many hours an order sits waiting inside the warehouse before being handed to a carrier, how many hours it spends riding on delivery trucks, and the total doorstep wait time."
    measures: [
      order_items.avg_warehouse_procrastination_hours,
      order_items.avg_truck_transit_hours,
      order_items.avg_total_doorstep_wait_hours
    ]
    filters: [
      order_items.is_shipped: "yes",
      order_items.is_delivered: "yes"
    ]
  }

  query: fulfillment_hours_by_status {
    description: "Breakdown of average hours to ship and average hours to deliver by order status for shipped items."
    dimensions: [order_items.status]
    measures: [
      order_items.avg_hours_to_ship,
      order_items.avg_hours_to_deliver
    ]
    filters: [order_items.is_shipped: "yes"]
  }

  query: weekend_warrior_shopping_surge {
    description: "Weekend Warrior Shopping Surge Ratio compares total sales, item volume, and average item price generated on Saturdays and Sundays against standard Monday-through-Friday weekday shopping."
    dimensions: [order_items.shopping_regime]
    measures: [
      order_items.count,
      order_items.total_revenue,
      order_items.avg_item_price
    ]
  }

  query: orders_and_revenue_by_day_of_week {
    description: "Daily rhythm of distinct customer orders and total sales across days of the week (1 = Sunday through 7 = Saturday)."
    dimensions: [order_items.created_day_of_week_num]
    measures: [
      order_items.distinct_orders,
      order_items.total_revenue
    ]
    sorts: [order_items.created_day_of_week_num: asc]
  }

  query: midnight_owl_impulse_spend_share {
    description: "Midnight Owl Impulse Spend Share calculates how much revenue and what share of store sales happen in the late-night hours between midnight and six in the morning."
    measures: [
      order_items.late_night_revenue,
      order_items.total_revenue,
      order_items.late_night_revenue_share
    ]
  }

  query: hourly_revenue_and_item_volume {
    description: "Hour-by-hour UTC curve of items bought and gross revenue across the 24-hour clock."
    dimensions: [order_items.created_hour_utc]
    measures: [
      order_items.count,
      order_items.total_revenue
    ]
    sorts: [order_items.created_hour_utc: asc]
  }
}
