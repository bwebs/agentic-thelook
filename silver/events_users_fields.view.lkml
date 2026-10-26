view: events_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(COALESCE(${users.id}, 0) AS STRING), '_', CAST(COALESCE(${events.id}, 0) AS STRING)) ;;
  }

  dimension: is_channel_crossover_event {
    label: "Channel Crossover Event"
    description: "Whether the browsing session traffic source differs from the customer's original signup marketing traffic source."
    synonyms: ["is mismatched source event", "is channel switch event", "crossover touchpoint"]
    type: yesno
    sql: ${events.traffic_source} != ${users.traffic_source} ;;
  }

  measure: channel_crossover_events {
    label: "Channel Crossover Events"
    description: "Count of website clickstream events where the session traffic channel differs from the customer's original signup marketing source."
    synonyms: ["crossover events", "mismatched source events", "channel switch events"]
    type: count
    filters: [is_channel_crossover_event: "yes"]
  }
}
