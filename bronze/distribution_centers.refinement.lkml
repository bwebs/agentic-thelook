include: "distribution_centers.view.lkml"

view: +distribution_centers {
  dimension: name {
    description: "Name of the physical fulfillment center (warehouse)."
    synonyms: ["warehouse name", "fulfillment center"]
  }

  dimension: logistics_belt {
    label: "Warehouse Sunbelt versus Rustbelt Classification"
    description: "Warehouse Sunbelt versus Rustbelt Classification groups our ten fulfillment centers and top high-density customer metro areas by geography into 'Pacific West Coast Gateway', 'Southern Gulf & Sunbelt Hub', 'East Coast Atlantic Port', and 'Midwest Heartland Freight Titan'. Operations planners use this regional network map for severe-weather contingency planning and freight balancing."
    synonyms: ["logistics belt", "warehouse sunbelt vs rustbelt", "sunbelt versus rustbelt classification", "regional freight belt"]
    alpha_sort: yes
    case: {
      when: {
        sql: ${longitude} < -110.0 ;;
        label: "Pacific West Coast Gateway"
      }
      when: {
        sql: ${latitude} < 34.0 ;;
        label: "Southern Gulf & Sunbelt Hub"
      }
      when: {
        sql: ${longitude} > -78.0 ;;
        label: "East Coast Atlantic Port"
      }
      else: "Midwest Heartland Freight Titan"
    }
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
