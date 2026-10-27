include: "/bronze/common_helpers.view.lkml"
include: "/bronze/inventory_items.view.lkml"
include: "/bronze/inventory_items.refinement.lkml"
include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"
include: "/bronze/explores/inventory_items_base.explore.lkml"
include: "/silver/inventory_items_fifo_batches.view.lkml"
include: "/silver/inventory_items_inventory_items_fifo_batches_fields.view.lkml"

explore: inventory_items {
  extends: [inventory_items_base]
  label: "Inventory Items"
  view_name: inventory_items
  hidden: no
  fields: [
    ALL_FIELDS*,
    -products.markup_greed_pct,
    -products.avg_markup_greed_pct
  ]

  join: distribution_centers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
  }

  join: inventory_items_fifo_batches {
    view_label: "Inventory Items"
    type: left_outer
    relationship: one_to_one
    sql_on: ${inventory_items.id} = ${inventory_items_fifo_batches.id} ;;
    fields: [
      inventory_items_fifo_batches.id,
      inventory_items_fifo_batches.oldest_unsold_stocked_raw,
      inventory_items_fifo_batches.oldest_unsold_stocked_time,
      inventory_items_fifo_batches.oldest_unsold_stocked_date,
      inventory_items_fifo_batches.total_sku_units_at_dc
    ]
  }

  join: inventory_items_inventory_items_fifo_batches_fields {
    view_label: "Inventory Items"
    sql: ;;
    relationship: one_to_one
  }

  query: warehouse_fifo_aging_anomaly_score {
    description: "Warehouse First-In-First-Out Aging Anomaly Score ranking fulfillment centers by FIFO violation rate alongside sold units, line-cutter shipments, and average days older stock was skipped."
    dimensions: [distribution_centers.name]
    measures: [
      inventory_items.sold_units,
      inventory_items_inventory_items_fifo_batches_fields.fifo_line_cutter_shipments,
      inventory_items_inventory_items_fifo_batches_fields.fifo_violation_rate,
      inventory_items_inventory_items_fifo_batches_fields.avg_days_older_unit_skipped
    ]
    filters: [distribution_centers.id: "NOT NULL"]
    sorts: [inventory_items_inventory_items_fifo_batches_fields.fifo_violation_rate: desc]
  }

  query: category_shelf_dwell_days_to_sell {
    description: "Top 15 clothing category and department combinations ranked by average days on shelf before sale alongside total stocked units and days-to-sell standard deviation."
    dimensions: [
      inventory_items.product_category,
      inventory_items.product_department
    ]
    measures: [
      inventory_items.count,
      inventory_items.avg_days_on_shelf,
      inventory_items.stddev_days_on_shelf
    ]
    sorts: [inventory_items.avg_days_on_shelf: desc]
    limit: 15
  }

  query: top_high_velocity_skus_by_sell_through {
    description: "Top 15 high-demand catalog SKUs (15+ units sold) ranked by sell-through rate and sold inventory volume alongside remaining unsold units."
    dimensions: [
      products.id,
      products.name,
      products.brand,
      products.category
    ]
    measures: [
      inventory_items.unsold_units,
      inventory_items.sold_units,
      inventory_items.sell_through_rate
    ]
    filters: [
      products.id: "NOT NULL",
      inventory_items.sold_units: ">=15"
    ]
    sorts: [
      inventory_items.sell_through_rate: desc,
      inventory_items.sold_units: desc
    ]
    limit: 15
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

  query: inventory_by_aging_tier {
    description: "Remaining unsold units, sold units, and total inventory cost across Vintage Dead-Stock Museum Artifact shelf aging tiers."
    dimensions: [inventory_items.inventory_aging_tier]
    measures: [
      inventory_items.unsold_units,
      inventory_items.sold_units,
      inventory_items.total_cost
    ]
    sorts: [inventory_items.inventory_aging_tier: asc]
  }

  query: unsold_museum_fossil_inventory_by_category {
    description: "Top 15 product categories ranked by unsold wholesale cash tied up in Museum Piece Fossil stock sitting on warehouse shelves for three or more years."
    dimensions: [inventory_items.product_category]
    measures: [
      inventory_items.unsold_units,
      inventory_items.sunk_dusty_shelf_cost
    ]
    filters: [
      inventory_items.is_sold: "no",
      inventory_items.inventory_aging_tier: "Museum Piece Fossil (3+ Years on Shelf)"
    ]
    sorts: [inventory_items.sunk_dusty_shelf_cost: desc]
    limit: 15
  }
}
