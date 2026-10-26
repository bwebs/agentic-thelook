include: "/bronze/explores/events_base.explore.lkml"

view: user_click_facts {
  label: "Customer Clickstream Facts"

  derived_table: {
    explore_source: events_base {
      column: user_id { field: events.user_id }
      column: total_clicks { field: events.count }
      filters: [events.user_id: "NOT NULL"]
    }
  }

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_clicks {
    label: "Customer Lifetime Clicks"
    description: "Cumulative website clickstream events recorded across the customer's lifetime (0 for registered accounts with no clickstream events)."
    synonyms: ["lifetime clicks", "user total clicks", "customer click count"]
    type: number
    sql: COALESCE(${TABLE}.total_clicks, 0) ;;
  }
}
