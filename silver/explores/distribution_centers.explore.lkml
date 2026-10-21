include: "../../bronze/distribution_centers.view.lkml"
include: "../../bronze/distribution_centers.refinement.lkml"

explore: distribution_centers {
  label: "Distribution Centers"
  view_name: distribution_centers

  query: total_warehouse_empire_count {
    description: "Total Warehouse Empire Count tracks how many physical fulfillment centers operate in our logistics network along with their average north-south geographic center. Executives drop this stat into investor pitch decks to highlight our nationwide supply chain footprint."
    measures: [distribution_centers.count, distribution_centers.mean_warehouse_latitude]
  }
}
