include: "/bronze/inventory_items.view.lkml"
include: "/bronze/inventory_items.refinement.lkml"
include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"
include: "/bronze/explores/inventory_items_base.explore.lkml"

explore: inventory_items {
  extends: [inventory_items_base]
  label: "Inventory Items"
  view_name: inventory_items
  hidden: no

  join: distribution_centers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
  }

  query: warehouse_hoarding_and_sell_through {
    description: "Warehouse Hoarding and Sell-Through Rate compares each fulfillment center's total inventory units, sold units, remaining unsold stock, and sell-through rate."
    dimensions: [distribution_centers.name]
    measures: [
      inventory_items.count,
      inventory_items.sold_units,
      inventory_items.unsold_units,
      inventory_items.sell_through_rate
    ]
    filters: [distribution_centers.id: "NOT NULL"]
    sorts: [inventory_items.sell_through_rate: desc]
  }

  query: warehouse_turnover_velocity {
    description: "Warehouse Turnover Velocity ranks fulfillment centers by the average days sold items sit on the shelf before selling alongside sold inventory cost."
    dimensions: [distribution_centers.name]
    measures: [
      inventory_items.avg_days_on_shelf,
      inventory_items.total_cost
    ]
    filters: [
      distribution_centers.id: "NOT NULL",
      inventory_items.is_sold: "yes"
    ]
    sorts: [inventory_items.avg_days_on_shelf: asc]
  }

  query: unsold_shelf_sitter_inventory {
    description: "Unsold Shelf-Sitter Inventory lists the oldest 25 physical stock units currently sitting unsold in a warehouse (sold_at is null) to determine live product availability."
    dimensions: [
      inventory_items.id,
      inventory_items.product_id,
      inventory_items.product_name,
      inventory_items.product_brand,
      inventory_items.cost,
      inventory_items.created_time
    ]
    filters: [inventory_items.is_sold: "no"]
    sorts: [inventory_items.created_time: asc]
    limit: 25
  }
}
