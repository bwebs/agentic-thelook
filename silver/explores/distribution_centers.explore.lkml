include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"
include: "/bronze/explores/distribution_centers_base.explore.lkml"
include: "/silver/warehouse_category_facts.view.lkml"
include: "/silver/warehouse_inventory_facts.view.lkml"
include: "/silver/warehouse_fulfillment_facts.view.lkml"

explore: distribution_centers {
  extends: [distribution_centers_base]
  label: "Distribution Centers"
  view_name: distribution_centers
  hidden: no

  join: warehouse_category_facts {
    view_label: "Warehouse Category Specialty Facts"
    type: left_outer
    relationship: one_to_many
    sql_on: ${distribution_centers.id} = ${warehouse_category_facts.dc_id} ;;
  }

  join: warehouse_inventory_facts {
    view_label: "Warehouse Inventory Ledger Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${distribution_centers.id} = ${warehouse_inventory_facts.dc_id} ;;
  }

  join: warehouse_fulfillment_facts {
    view_label: "Warehouse Fulfillment Physics & P&L Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${distribution_centers.id} = ${warehouse_fulfillment_facts.dc_id} ;;
  }

  query: warehouse_gravity_well_profit_efficiency_scorecard {
    description: "Warehouse Gravity Well and Supply Chain Profit Efficiency unified P&L scorecard benchmarking every fulfillment center across stocked SKUs, deployed capital, dead-stock drag, turn days, fulfilled items, gross revenue, retained net profit, return drag, pick-pack speed, and net profit per 1,000 shipment km."
    dimensions: [
      distribution_centers.id,
      distribution_centers.name
    ]
    measures: [
      warehouse_inventory_facts.total_distinct_skus_stocked,
      warehouse_inventory_facts.total_warehouse_capital_deployed,
      warehouse_inventory_facts.total_dead_stock_drag,
      warehouse_inventory_facts.avg_warehouse_turn_days,
      warehouse_fulfillment_facts.total_fulfilled_order_items,
      warehouse_fulfillment_facts.total_gross_revenue,
      warehouse_fulfillment_facts.total_retained_net_profit,
      warehouse_fulfillment_facts.return_drag_rate,
      warehouse_fulfillment_facts.avg_warehouse_pick_pack_hours,
      warehouse_fulfillment_facts.net_profit_per_1000_shipment_km
    ]
    filters: [
      warehouse_inventory_facts.dc_id: "NOT NULL",
      warehouse_fulfillment_facts.dc_id: "NOT NULL"
    ]
    sorts: [warehouse_fulfillment_facts.net_profit_per_1000_shipment_km: desc]
  }

  query: total_warehouse_empire_count {
    description: "Total Warehouse Empire Count tracks how many physical fulfillment centers operate in our logistics network along with their average north-south geographic center. Executives drop this stat into investor pitch decks to highlight our nationwide supply chain footprint."
    measures: [distribution_centers.count, distribution_centers.mean_warehouse_latitude]
  }

  query: warehouse_logistics_belts {
    description: "Physical fulfillment centers classified by Warehouse Sunbelt versus Rustbelt Classification with geographic coordinates."
    dimensions: [
      distribution_centers.id,
      distribution_centers.name,
      distribution_centers.latitude,
      distribution_centers.longitude,
      distribution_centers.logistics_belt
    ]
    sorts: [
      distribution_centers.logistics_belt: asc,
      distribution_centers.name: asc
    ]
  }

  query: warehouse_specialty_tiers {
    description: "Outbound product category count, units sold, gross tier revenue, and top signature categories across Warehouse Specialty Monopoly Tag tiers for each fulfillment center."
    dimensions: [
      distribution_centers.name,
      warehouse_category_facts.warehouse_specialty_tier
    ]
    measures: [
      warehouse_category_facts.count,
      warehouse_category_facts.total_sold_units,
      warehouse_category_facts.total_category_revenue,
      warehouse_category_facts.top_signature_categories
    ]
    filters: [warehouse_category_facts.dc_id: "NOT NULL"]
    sorts: [
      distribution_centers.name: asc,
      warehouse_category_facts.warehouse_specialty_tier: asc
    ]
  }
}
