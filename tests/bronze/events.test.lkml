include: "../../silver/explores/events.explore.lkml"

test: events_refinement_metrics {
  explore_source: events {
    column: count { field: events.count }
    column: unique_chaotic_sessions { field: events.unique_chaotic_sessions }
    column: distinct_clicking_humans { field: events.distinct_clicking_humans }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
  }
  assert: count_matches {
    expression: ${events.count} = 774 ;;
  }
  assert: unique_chaotic_sessions_matches {
    expression: ${events.unique_chaotic_sessions} = 251 ;;
  }
  assert: distinct_clicking_humans_matches {
    expression: ${events.distinct_clicking_humans} = 63 ;;
  }
}

test: events_rage_quit_abandonment_metrics {
  explore_source: events {
    column: cart_events { field: events.cart_events }
    column: purchase_events { field: events.purchase_events }
    column: cancel_events { field: events.cancel_events }
    column: carts_per_purchase_ratio { field: events.carts_per_purchase_ratio }
    column: cancel_to_cart_ratio { field: events.cancel_to_cart_ratio }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
  }
  assert: cart_events_matches {
    expression: ${events.cart_events} = 191 ;;
  }
  assert: purchase_events_matches {
    expression: ${events.purchase_events} = 63 ;;
  }
  assert: cancel_events_matches {
    expression: ${events.cancel_events} = 44 ;;
  }
  assert: carts_per_purchase_ratio_matches {
    expression: round(${events.carts_per_purchase_ratio}, 2) = 3.03 ;;
  }
  assert: cancel_to_cart_ratio_matches {
    expression: round(${events.cancel_to_cart_ratio}, 4) = 0.2304 ;;
  }
}

test: events_ie_dinosaur_2024_01_01_metrics {
  explore_source: events {
    column: ie_events { field: events.ie_events }
    column: count { field: events.count }
    column: ie_event_share { field: events.ie_event_share }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
  }
  assert: ie_events_matches {
    expression: ${events.ie_events} = 75 ;;
  }
  assert: count_matches {
    expression: ${events.count} = 922 ;;
  }
  assert: ie_event_share_matches {
    expression: round(${events.ie_event_share}, 4) = 0.0813 ;;
  }
}

test: events_2024_01_01_max_sequence_metrics {
  explore_source: events {
    column: max_sequence_number { field: events.max_sequence_number }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
  }
  assert: max_sequence_number_matches {
    expression: ${events.max_sequence_number} = 13 ;;
  }
}

test: events_2024_01_01_deep_link_metrics {
  explore_source: events {
    column: avg_url_path_depth { field: events.avg_url_path_depth }
    column: department_url_events { field: events.department_url_events }
    column: category_url_events { field: events.category_url_events }
    column: brand_url_events { field: events.brand_url_events }
    column: approx_unique_sessions { field: events.approx_unique_sessions }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
  }
  assert: avg_url_path_depth_matches {
    expression: round(${events.avg_url_path_depth}, 2) = 2.6 ;;
  }
  assert: department_url_events_matches {
    expression: ${events.department_url_events} = 232 ;;
  }
  assert: category_url_events_matches {
    expression: ${events.category_url_events} = 232 ;;
  }
  assert: brand_url_events_matches {
    expression: ${events.brand_url_events} = 232 ;;
  }
  assert: approx_unique_sessions_matches {
    expression: ${events.approx_unique_sessions} = 267 ;;
  }
}

test: events_2024_01_01_uri_segment_metrics {
  explore_source: events {
    column: count { field: events.count }
    column: approx_unique_sessions { field: events.approx_unique_sessions }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
    filters: {
      field: events__uri_segments.url_directory_depth_level
      value: "<=2"
    }
    filters: {
      field: events__uri_segments.uri_segment
      value: "department"
    }
  }
  assert: count_matches {
    expression: ${events.count} = 232 ;;
  }
  assert: approx_unique_sessions_matches {
    expression: ${events.approx_unique_sessions} = 152 ;;
  }
}

test: events_2024_01_01_browser_persona {
  explore_source: events {
    column: browser_persona { field: events.browser_persona }
    column: count { field: events.count }
    filters: [events.created_date: "2024-01-01"]
    sorts: [events.browser_persona: asc]
  }
  assert: browser_persona_counts_match {
    expression: index(${events.browser_persona}, 1) = "Google Chrome RAM Eater"
      AND index(${events.count}, 1) = 428
      AND index(${events.browser_persona}, 2) = "Apple Walled-Garden Safari Snob"
      AND index(${events.count}, 2) = 193
      AND index(${events.browser_persona}, 3) = "Open-Source Firefox Privacy Nerd"
      AND index(${events.count}, 3) = 187
      AND index(${events.browser_persona}, 4) = "Time-Traveler Internet Explorer Dinosaur"
      AND index(${events.count}, 4) = 22
      AND index(${events.browser_persona}, 5) = "Mystery Smart-Fridge / Other Browser"
      AND index(${events.count}, 5) = 50 ;;
  }
}

test: events_2024_01_01_session_span_and_click_trail_metrics {
  explore_source: events {
    column: session_id { field: events.session_id }
    column: count { field: events.count }
    column: event_span_minutes { field: events.event_span_minutes }
    column: click_trail { field: events.click_trail }
    filters: {
      field: events.created_date
      value: "2024-01-01"
    }
    filters: {
      field: events.count
      value: ">=5"
    }
    sorts: [events.session_id: asc]
  }
  assert: first_session_span_and_trail_matches {
    expression: index(${events.session_id}, 1) = "00a05f63-5d71-49ee-bccf-7f0103c94dc0" AND index(${events.count}, 1) = 6 AND index(${events.event_span_minutes}, 1) = 10 AND index(${events.click_trail}, 1) = "department>product>cart>department>product>cart" ;;
  }
  assert: second_session_converting_trail_matches {
    expression: index(${events.session_id}, 2) = "0419867a-8983-474c-8982-c19c5ed7b378" AND index(${events.count}, 2) = 5 AND index(${events.event_span_minutes}, 2) = 7 AND index(${events.click_trail}, 2) = "home>department>product>cart>purchase" ;;
  }
}

test: events_2024_01_01_funnel_page_events {
  explore_source: events {
    column: home_events { field: events.home_events }
    column: department_events { field: events.department_events }
    column: product_events { field: events.product_events }
    filters: [events.created_date: "2024-01-01"]
  }
  assert: home_events_matches {
    expression: ${events.home_events} = 30 ;;
  }
  assert: department_events_matches {
    expression: ${events.department_events} = 223 ;;
  }
  assert: product_events_matches {
    expression: ${events.product_events} = 308 ;;
  }
}

test: events_distinct_traffic_sources_2024_01_01 {
  explore_source: events {
    column: distinct_traffic_sources { field: events.distinct_traffic_sources }
    column: count { field: events.count }
    filters: [events.created_date: "2024-01-01"]
  }
  assert: distinct_traffic_sources_matches {
    expression: ${events.distinct_traffic_sources} = 5 ;;
  }
  assert: event_count_matches {
    expression: ${events.count} = 880 ;;
  }
}
