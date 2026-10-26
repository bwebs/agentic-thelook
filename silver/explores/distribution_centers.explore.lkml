include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"
include: "/bronze/explores/distribution_centers_base.explore.lkml"
include: "/silver/warehouse_category_facts.view.lkml"

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
