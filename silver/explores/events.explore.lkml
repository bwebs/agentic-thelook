include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"
include: "/bronze/explores/events_base.explore.lkml"
include: "/silver/event_session_facts.view.lkml"

explore: events {
  extends: [events_base]
  label: "Events"
  view_name: events
  hidden: no

  join: event_session_facts {
    view_label: "Purchasing Session Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${events.session_id} = ${event_session_facts.session_id} ;;
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
}
