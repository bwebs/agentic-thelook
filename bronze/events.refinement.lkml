include: "events.view.lkml"

view: +events {
  measure: count {
    label: "Total Click Events"
    description: "Total volume of website interactions and clickstream events."
  }

  measure: unique_chaotic_sessions {
    label: "Unique Browsing Sessions"
    description: "Number of unique browsing sessions generating storefront traffic."
    type: count_distinct
    sql: ${session_id} ;;
  }

  measure: distinct_clicking_humans {
    label: "Distinct Clicking Shoppers"
    description: "Number of distinct shoppers generating website interactions."
    type: count_distinct
    sql: ${user_id} ;;
  }
}
