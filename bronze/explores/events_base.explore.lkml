include: "../events.view.lkml"
include: "../events.refinement.lkml"
include: "../events__uri_segments.view.lkml"

explore: events_base {
  label: "Events"
  view_name: events
  hidden: yes

  join: events__uri_segments {
    view_label: "Event URI Segments"
    sql: LEFT JOIN UNNEST(${events.uri_segments}) AS events__uri_segments WITH OFFSET AS events__uri_segments_offset ;;
    relationship: one_to_many
  }

  query: total_browser_click_frenzy_volume {
    description: "Total Browser Click Frenzy Volume counts the total volume of website interactions alongside the number of unique browsing sessions and distinct shoppers generating that traffic. Platform engineering and marketing teams track this activity to gauge top-of-funnel storefront engagement and peak site load."
    measures: [
      events.count,
      events.unique_chaotic_sessions,
      events.distinct_clicking_humans
    ]
  }

  query: rage_quit_cart_abandonment_ratio {
    description: "Rage-Quit Cart Abandonment Ratio compares how often shoppers add items to their cart or explicitly cancel out of a browsing flow relative to completed checkouts."
    measures: [
      events.cart_events,
      events.purchase_events,
      events.cancel_events,
      events.carts_per_purchase_ratio,
      events.cancel_to_cart_ratio
    ]
  }

  query: funnel_events_by_traffic_source {
    description: "Cart, purchase, and cancellation event volume across acquisition traffic channels ordered by cart volume."
    dimensions: [events.traffic_source]
    measures: [
      events.cart_events,
      events.purchase_events,
      events.cancel_events
    ]
    sorts: [events.cart_events: desc]
  }

  query: ie_dinosaur_tax_share {
    description: "Internet Explorer Dinosaur Tax tracks legacy Internet Explorer event volume, total website events, and the share of website traffic still coming from IE browsers."
    measures: [
      events.ie_events,
      events.count,
      events.ie_event_share
    ]
  }

  query: event_volume_and_sessions_by_browser {
    description: "Website clickstream event volume and unique browsing sessions broken down by browser."
    dimensions: [events.browser]
    measures: [
      events.count,
      events.unique_chaotic_sessions
    ]
    sorts: [events.count: desc]
  }

  query: browser_and_event_type_volume_since_2024 {
    description: "Top 15 browser and event type combinations by clickstream event volume since 2024-01-01."
    dimensions: [
      events.browser,
      events.event_type
    ]
    measures: [events.count]
    filters: [events.created_date: "after 2024/01/01"]
    sorts: [events.count: desc]
    limit: 15
  }

  query: deep_link_engagement_by_event_type {
    description: "Clickstream Deep-Link Engagement breakdown by event type: total events, average URL path depth, and deep-link hits across department, category, and brand URLs."
    dimensions: [events.event_type]
    measures: [
      events.count,
      events.avg_url_path_depth,
      events.department_url_events,
      events.category_url_events,
      events.brand_url_events
    ]
    sorts: [events.count: desc]
  }

  query: top_decoded_category_deep_links {
    description: "Top 15 decoded URL categories by category page click hits and unique browsing sessions."
    dimensions: [events.decoded_url_category]
    measures: [
      events.count,
      events.unique_chaotic_sessions
    ]
    filters: [events.uri: "%/category/%"]
    sorts: [events.count: desc]
    limit: 15
  }

  query: top_uri_segments_by_directory_depth {
    description: "Top 20 non-empty URI path segments across the first three directory depth levels (0..2) by click hits and approximate unique sessions."
    dimensions: [
      events__uri_segments.url_directory_depth_level,
      events__uri_segments.uri_segment
    ]
    measures: [
      events.count,
      events.approx_unique_sessions
    ]
    filters: [
      events__uri_segments.url_directory_depth_level: "<=2",
      events__uri_segments.uri_segment: "-EMPTY"
    ]
    sorts: [
      events.count: desc,
      events__uri_segments.uri_segment: asc
    ]
    limit: 20
  }
}
