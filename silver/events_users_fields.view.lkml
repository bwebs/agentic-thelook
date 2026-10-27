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

  dimension: is_away_from_home_event {
    label: "Away-from-Home Browsing Event"
    description: "Whether the clickstream event city differs from the customer's registered home billing city."
    synonyms: ["is away from home event", "travel browsing event"]
    type: yesno
    sql: ${events.city} != ${users.city} ;;
  }

  measure: away_from_home_events {
    label: "Away-from-Home Browsing Events"
    description: "Count of website clickstream events where the browsing city differs from the customer's registered home billing city."
    synonyms: ["away from home events", "out-of-town click events"]
    type: count
    filters: [is_away_from_home_event: "yes"]
  }
}
