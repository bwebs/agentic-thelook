include: "users.view.lkml"

view: +users {
  measure: count {
    description: "Total number of registered shopper accounts."
    synonyms: ["registered users", "registered customers"]
  }

  measure: avg_customer_age {
    label: "Average Customer Wisdom Level"
    description: "Average Customer Wisdom Level measures the mean age of our registered shopper base alongside the youngest and oldest customers on file. The social media marketing team checks this demographic pulse to decide how much creative budget goes toward youth channels versus older audiences."
    synonyms: ["average shopper age", "avg user age"]
    type: average
    sql: ${age} ;;
    value_format_name: decimal_2
  }

  measure: youngest_shopper_age {
    label: "Youngest Shopper Age"
    description: "Minimum age of our registered shopper base on file."
    type: min
    sql: ${age} ;;
  }

  measure: oldest_shopper_age {
    label: "Oldest Shopper Age"
    description: "Maximum age of our registered shopper base on file."
    type: max
    sql: ${age} ;;
  }
}
