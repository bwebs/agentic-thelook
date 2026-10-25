include: "/bronze/explores/events_base.explore.lkml"

view: event_session_facts {
  label: "Purchasing Session Facts"

  derived_table: {
    explore_source: events_base {
      column: session_id { field: events.session_id }
      column: session_seconds { field: events._event_span_seconds }
      column: max_steps { field: events.max_sequence_number }
      filters: [events.purchase_events: ">0"]
    }
  }

  dimension: session_id {
    primary_key: yes
    label: "Purchasing Session ID"
    description: "Unique session identifier for browsing sessions that completed at least one purchase event."
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: session_seconds {
    label: "Checkout Session Duration (Seconds)"
    description: "Elapsed seconds from a converting shopper's very first click in a session to completing their final session event."
    synonyms: ["checkout duration seconds", "session duration seconds"]
    type: number
    sql: ${TABLE}.session_seconds ;;
  }

  dimension: max_steps {
    label: "Max Checkout Steps"
    description: "Maximum clickstream sequence step number reached by a converting shopper during a purchasing session."
    synonyms: ["checkout steps", "steps taken", "session max steps"]
    type: number
    sql: ${TABLE}.max_steps ;;
  }

  measure: count {
    label: "Purchasing Sessions"
    description: "Total number of converting browsing sessions that completed at least one purchase event."
    synonyms: ["total purchasing sessions", "converting sessions", "checkout sessions"]
    type: count
  }

  measure: min_checkout_duration_sec {
    label: "Fastest Checkout Duration (Seconds)"
    description: "Speed-Runner Checkout Score minimum: fastest elapsed seconds from first session click to purchase completion across converting sessions."
    synonyms: ["world record fastest checkout sec", "fastest checkout seconds", "speed-runner fastest checkout"]
    tags: ["non_additive"]
    type: min
    sql: ${session_seconds} ;;
  }

  measure: avg_checkout_duration_sec {
    label: "Average Checkout Duration (Seconds)"
    description: "Speed-Runner Checkout Score benchmark: average elapsed seconds it takes a converting shopper to go from their very first click in a session to completing a purchase."
    synonyms: ["speed-runner checkout score", "avg checkout duration sec", "avg duration sec", "average checkout seconds"]
    tags: ["non_additive"]
    type: average
    sql: ${session_seconds} ;;
    value_format_name: decimal_2
  }

  measure: max_checkout_duration_sec {
    label: "Slowest Checkout Duration (Seconds)"
    description: "Speed-Runner Checkout Score maximum: slowest elapsed seconds (most indecisive checkout) from first session click to purchase completion across converting sessions."
    synonyms: ["most indecisive checkout sec", "slowest checkout seconds", "max checkout seconds"]
    tags: ["non_additive"]
    type: max
    sql: ${session_seconds} ;;
  }
}
