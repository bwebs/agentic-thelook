include: "../distribution_centers.view.lkml"
include: "../distribution_centers.refinement.lkml"

explore: distribution_centers {
  label: "Distribution Centers"
  view_name: distribution_centers
  hidden: no

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
}
