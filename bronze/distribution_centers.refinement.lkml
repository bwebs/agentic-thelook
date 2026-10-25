include: "distribution_centers.view.lkml"

view: +distribution_centers {
  dimension: name {
    description: "Name of the physical fulfillment center (warehouse)."
    synonyms: ["warehouse name", "fulfillment center"]
  }

  measure: count {
    label: "Total Warehouse Empire Count"
    description: "Total Warehouse Empire Count tracks how many physical fulfillment centers operate in our logistics network along with their average north-south geographic center. Executives drop this stat into investor pitch decks to highlight our nationwide supply chain footprint."
  }

  measure: mean_warehouse_latitude {
    label: "Mean Warehouse Latitude"
    description: "Average north-south geographic center (latitude) across physical fulfillment centers in the logistics network."
    type: average
    sql: ${latitude} ;;
    value_format_name: decimal_4
  }
}
