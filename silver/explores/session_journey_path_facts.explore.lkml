include: "/silver/session_journey_path_facts.view.lkml"

explore: session_journey_path_facts {
  label: "Clickstream Session Journey Paths"
  view_name: session_journey_path_facts
  hidden: no

  query: top_session_journey_paths {
    description: "Top 15 clickstream session journey paths and conversion outcomes ranked by session frequency alongside their share of all browsing sessions."
    dimensions: [
      session_journey_path_facts.click_journey_path,
      session_journey_path_facts.is_converted_to_purchase
    ]
    measures: [
      session_journey_path_facts.session_frequency,
      session_journey_path_facts.share_of_all_sessions
    ]
    sorts: [session_journey_path_facts.session_frequency: desc]
    limit: 15
  }
}
