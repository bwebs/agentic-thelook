include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/explores/orders_base.explore.lkml"
include: "/silver/order_basket_facts.view.lkml"
include: "/silver/order_purchase_cooldowns.view.lkml"
include: "/silver/orders_sequenced.view.lkml"
include: "/silver/user_spend_trajectory_facts.view.lkml"

explore: orders {
  extends: [orders_base]
  label: "Orders"
  view_name: orders
  hidden: no

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${orders.user_id} = ${users.id} ;;
  }

  join: orders_sequenced {
    view_label: "Orders"
    type: left_outer
    relationship: one_to_one
    sql_on: ${orders.order_id} = ${orders_sequenced.order_id} ;;
    fields: [
      orders_sequenced.order_id,
      orders_sequenced.prev_order_raw,
      orders_sequenced.prev_order_time,
      orders_sequenced.prev_order_date,
      orders_sequenced.days_inter_order_gap,
      orders_sequenced.max_inter_order_gap_days
    ]
  }

  join: order_purchase_cooldowns {
    view_label: "Orders"
    type: left_outer
    relationship: one_to_one
    sql_on: ${orders.order_id} = ${order_purchase_cooldowns.order_id} ;;
    fields: [
      order_purchase_cooldowns.order_id,
      order_purchase_cooldowns.order_sequence,
      order_purchase_cooldowns.is_repeat_order,
      order_purchase_cooldowns.cooldown_days,
      order_purchase_cooldowns.repeat_orders,
      order_purchase_cooldowns.avg_dopamine_cooldown_days,
      order_purchase_cooldowns.min_cooldown_hours,
      order_purchase_cooldowns.max_cooldown_days,
      order_purchase_cooldowns.avg_whole_cooldown_days
    ]
  }

  join: order_basket_facts {
    view_label: "Order Basket Composition Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${orders.order_id} = ${order_basket_facts.order_id} ;;
  }

  join: user_spend_trajectory_facts {
    view_label: "Customer Spend Trajectory Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${orders.order_id} = ${user_spend_trajectory_facts.order_id} ;;
  }

  query: inter_order_dopamine_cooldown_by_milestone {
    description: "Inter-Order Dopamine Cooldown order count, average cooldown days, minimum cooldown hours, and maximum cooldown days across repeat purchase sequence milestones."
    dimensions: [order_purchase_cooldowns.order_sequence]
    measures: [
      order_purchase_cooldowns.repeat_orders,
      order_purchase_cooldowns.avg_dopamine_cooldown_days,
      order_purchase_cooldowns.min_cooldown_hours,
      order_purchase_cooldowns.max_cooldown_days
    ]
    filters: [order_purchase_cooldowns.is_repeat_order: "yes"]
    sorts: [order_purchase_cooldowns.order_sequence: asc]
  }

  query: repeat_order_cooldown_by_traffic_source {
    description: "Repeat order transitions and average whole days between consecutive orders broken down by customer acquisition traffic source."
    dimensions: [users.traffic_source]
    measures: [
      order_purchase_cooldowns.repeat_orders,
      order_purchase_cooldowns.avg_whole_cooldown_days
    ]
    filters: [
      users.id: "NOT NULL",
      order_purchase_cooldowns.is_repeat_order: "yes"
    ]
    sorts: [order_purchase_cooldowns.avg_whole_cooldown_days: asc]
  }

  query: repeat_customer_order_spend_escalation {
    description: "Repeat customer count, average order spend, average baseline first-order spend, and Second-Order Price Escalation Multiplier across chronological purchase sequence steps."
    dimensions: [user_spend_trajectory_facts.order_sequence_number]
    measures: [
      orders.distinct_users,
      user_spend_trajectory_facts.avg_order_spend,
      user_spend_trajectory_facts.avg_first_order_spend,
      user_spend_trajectory_facts.avg_spend_escalation_multiplier
    ]
    filters: [user_spend_trajectory_facts.user_order_count: ">=2"]
    sorts: [user_spend_trajectory_facts.order_sequence_number: asc]
  }

  query: resurrected_lazarus_orders {
    description: "Top 15 reactivated Lazarus shopper orders placed after 180+ days of dormancy, ranked by days in hibernation."
    dimensions: [
      orders.user_id,
      users.full_name,
      users.age,
      users.country,
      orders_sequenced.prev_order_time,
      orders.created_time,
      orders_sequenced.days_inter_order_gap
    ]
    filters: [
      users.id: "NOT NULL",
      orders_sequenced.days_inter_order_gap: ">=180"
    ]
    sorts: [orders_sequenced.days_inter_order_gap: desc]
    limit: 15
  }

  query: orders_by_basket_diversity_archetype {
    description: "Order volume, average units in basket, average distinct brands, average basket spend, and total revenue across Outfit Builder versus Monoculture Hoarder Basket Archetypes."
    dimensions: [order_basket_facts.basket_diversity_archetype]
    measures: [
      orders.count,
      order_basket_facts.avg_basket_units,
      order_basket_facts.avg_basket_distinct_brands,
      order_basket_facts.avg_basket_spend,
      order_basket_facts.total_basket_revenue
    ]
    filters: [order_basket_facts.order_id: "NOT NULL"]
    sorts: [order_basket_facts.basket_diversity_archetype: asc]
  }

  query: multi_item_baskets_by_category_diversity {
    description: "Multi-item order count (2+ items), average items per basket, average distinct brands, and average basket revenue broken down by distinct clothing categories in the basket."
    dimensions: [order_basket_facts.distinct_categories]
    measures: [
      orders.count,
      order_basket_facts.avg_basket_units,
      order_basket_facts.avg_basket_distinct_brands,
      order_basket_facts.avg_basket_spend
    ]
    filters: [order_basket_facts.total_units: ">=2"]
    sorts: [order_basket_facts.distinct_categories: asc]
  }

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
