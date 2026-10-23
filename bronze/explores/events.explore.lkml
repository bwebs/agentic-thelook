include: "../events.view.lkml"
include: "../events.refinement.lkml"

explore: events {
  label: "Events"
  view_name: events
  hidden: no

  query: total_browser_click_frenzy_volume {
    description: "Total Browser Click Frenzy Volume counts the total volume of website interactions alongside the number of unique browsing sessions and distinct shoppers generating that traffic. Platform engineering and marketing teams track this activity to gauge top-of-funnel storefront engagement and peak site load."
    measures: [
      events.count,
      events.unique_chaotic_sessions,
      events.distinct_clicking_humans
    ]
  }
}
