include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"
include: "/bronze/events__uri_segments.view.lkml"
include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/silver/explores/events_steps_base.explore.lkml"
include: "/silver/browsing_session_facts.view.lkml"
include: "/silver/event_session_facts.view.lkml"
include: "/silver/event_session_steps.view.lkml"
include: "/silver/event_step_transitions.view.lkml"
include: "/silver/events_users_fields.view.lkml"

explore: events {
  extends: [events_steps_base]
  label: "Events"
  view_name: events
  hidden: no

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${events.user_id} = ${users.id} ;;
  }

  join: events_users_fields {
    view_label: "Events"
    sql: ;;
    relationship: one_to_one
  }

  join: browsing_session_facts {
    view_label: "Browsing Session Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${events.session_id} = ${browsing_session_facts.session_id} ;;
  }

  join: event_session_facts {
    view_label: "Purchasing Session Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
  }

  join: event_session_steps {
    view_label: "Events"
    type: left_outer
    relationship: one_to_one
    sql_on: ${events.id} = ${event_session_steps.id} ;;
    fields: [
      id,
      step_asc,
      step_desc,
      session_total_events,
      session_structural_role
    ]
  }

  join: event_step_transitions {
    view_label: "Events"
    type: left_outer
    relationship: one_to_one
    sql_on: ${events.id} = ${event_step_transitions.id} ;;
    fields: [
      id,
      to_state,
      step_dwell_seconds,
      avg_seconds_before_transition
    ]
  }

  query: session_purchase_rate_by_traffic_source {
    description: "Total browsing sessions, purchasing sessions, and session purchase conversion rate broken down by session traffic source."
    dimensions: [events.traffic_source]
    measures: [
      events.unique_chaotic_sessions,
      events.purchasing_sessions,
      events.session_purchase_rate
    ]
    sorts: [events.session_purchase_rate: desc]
  }

  query: browser_cart_to_cancel_friction {
    description: "Unique browsing sessions, cart events, cancel events, purchase events, and cart-to-cancel abandonment ratio broken down by browser."
    dimensions: [events.browser]
    measures: [
      events.unique_chaotic_sessions,
      events.cart_events,
      events.cancel_events,
      events.purchase_events,
      events.cancel_to_cart_ratio
    ]
    sorts: [events.cancel_to_cart_ratio: desc]
  }

  query: sessions_and_url_depth_by_country {
    description: "Total browsing sessions, average URL path depth, and purchase events for signed-in shoppers across countries."
    dimensions: [users.country]
    measures: [
      events.unique_chaotic_sessions,
      events.avg_url_path_depth,
      events.purchase_events
    ]
    filters: [users.id: "NOT NULL"]
    sorts: [events.unique_chaotic_sessions: desc]
  }

  query: channel_crossover_events_by_source {
    description: "Top 15 customer signup-to-session channel crossover pairs ranked by crossover clickstream event volume."
    dimensions: [users.traffic_source, events.traffic_source]
    measures: [users.count, events.count]
    filters: [
      users.id: "NOT NULL",
      events_users_fields.is_channel_crossover_event: "yes"
    ]
    sorts: [events.count: desc]
    limit: 15
  }

  query: sessions_by_clickstream_loop_archetype {
    description: "Browsing session volume, average clickstream steps per session, and session purchase conversion rate across Clickstream Indecision Loop Archetypes."
    dimensions: [browsing_session_facts.clickstream_loop_archetype]
    measures: [
      browsing_session_facts.count,
      browsing_session_facts.avg_events_per_session,
      browsing_session_facts.session_conversion_rate
    ]
    sorts: [browsing_session_facts.clickstream_loop_archetype: asc]
  }

  query: top_clickstream_step_triplets {
    description: "Top 15 consecutive three-step clickstream transitions (prev_event -> curr_event -> next_event) ranked by occurrence count alongside distinct browsing sessions."
    dimensions: [event_step_triplets.oscillation_triplet]
    measures: [events.count, events.unique_chaotic_sessions]
    filters: [
      event_step_triplets.prev_event_type: "-NULL",
      event_step_triplets.next_event_type: "-NULL"
    ]
    sorts: [events.count: desc]
    limit: 15
  }

  query: speed_runner_checkout_score {
    description: "Speed-Runner Checkout Score measures the fastest, average, and slowest checkout duration in seconds alongside total purchasing sessions for converting shoppers."
    measures: [
      event_session_facts.min_checkout_duration_sec,
      event_session_facts.avg_checkout_duration_sec,
      event_session_facts.max_checkout_duration_sec,
      event_session_facts.count
    ]
    filters: [event_session_facts.session_id: "-NULL"]
  }

  query: checkout_duration_by_max_steps {
    description: "Purchasing session volume and average checkout duration in seconds broken down by the maximum number of clickstream steps taken in the session."
    dimensions: [event_session_facts.max_steps]
    measures: [
      event_session_facts.count,
      event_session_facts.avg_checkout_duration_sec
    ]
    filters: [event_session_facts.session_id: "-NULL"]
    sorts: [event_session_facts.max_steps: asc]
  }

  query: session_structural_role_by_event_type {
    description: "Clickstream event volume broken down by First-Touch versus Last-Touch Session Event Role and event type."
    dimensions: [event_session_steps.session_structural_role, events.event_type]
    measures: [events.count]
    sorts: [event_session_steps.session_structural_role: asc, events.count: desc]
  }

  query: browser_modernity_personas {
    description: "Total clickstream events and unique browsing sessions broken down by Browser Modernity Persona."
    dimensions: [events.browser_persona]
    measures: [events.count, events.unique_chaotic_sessions]
    sorts: [events.count: desc]
  }

  query: browser_persona_by_traffic_source_2025 {
    description: "Clickstream event volume since 2025-01-01 broken down by Browser Modernity Persona and traffic source."
    dimensions: [events.browser_persona, events.traffic_source]
    measures: [events.count]
    filters: [events.created_date: "after 2025/01/01"]
    sorts: [events.count: desc]
  }

  query: session_marathon_tier_conversion {
    description: "Browsing sessions, converting sessions, and purchase conversion rate across Clickstream Binge-Scroll Marathon Tiers."
    dimensions: [browsing_session_facts.session_marathon_tier]
    measures: [
      browsing_session_facts.count,
      browsing_session_facts.converted_sessions,
      browsing_session_facts.session_conversion_rate
    ]
    sorts: [browsing_session_facts.session_marathon_tier: asc]
  }

  query: top_marathon_sessions_click_trails {
    description: "Top 15 Doom-Scroll Fashion Marathon sessions (10+ events) ranked by event count with session duration in minutes and full clickstream event trail."
    dimensions: [events.session_id, events.user_id]
    measures: [
      events.count,
      events.event_span_minutes,
      events.click_trail
    ]
    filters: [events.count: ">=10"]
    sorts: [events.count: desc]
    limit: 15
  }

  query: sessions_by_funnel_archetype {
    description: "Browsing session volume and average clickstream events per session across Clickstream Cart-Abandoner versus Decisive Closer Session Archetypes."
    dimensions: [browsing_session_facts.session_funnel_archetype]
    measures: [
      browsing_session_facts.count,
      browsing_session_facts.avg_events_per_session
    ]
    sorts: [browsing_session_facts.session_funnel_archetype: asc]
  }

  query: funnel_sessions_by_browser_and_traffic_source {
    description: "Top 15 browser and traffic source combinations ranked by completed purchase sessions alongside silent cart abandon sessions and explicit cancel sessions."
    dimensions: [events.browser, events.traffic_source]
    measures: [
      browsing_session_facts.silent_cart_abandon_sessions,
      browsing_session_facts.explicit_cancel_sessions,
      browsing_session_facts.converted_sessions
    ]
    sorts: [browsing_session_facts.converted_sessions: desc]
    limit: 15
  }
}
