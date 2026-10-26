include: "/silver/explores/events.explore.lkml"

view: user_click_facts {
  label: "Customer Clickstream Facts"

  derived_table: {
    explore_source: events {
      column: user_id { field: events.user_id }
      column: total_clicks { field: events.count }
      column: distinct_event_sources { field: events.distinct_traffic_sources }
      column: mismatched_source_events { field: events_users_fields.channel_crossover_events }
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

  dimension: distinct_event_sources {
    label: "Distinct Clickstream Channels Touched"
    group_label: "Channel Attribution"
    description: "Number of distinct marketing traffic channels touched across all of the customer's browsing events."
    synonyms: ["distinct event sources", "channels touched", "session channel count"]
    type: number
    sql: ${TABLE}.distinct_event_sources ;;
  }

  dimension: mismatched_source_events {
    label: "Mismatched-Channel Click Events"
    group_label: "Channel Attribution"
    description: "Number of customer clickstream events whose session traffic source differed from the customer's original signup marketing source."
    synonyms: ["mismatched source events", "crossover click events"]
    type: number
    sql: ${TABLE}.mismatched_source_events ;;
  }

  dimension: channel_attribution_persona {
    label: "Channel Chameleon versus Single-Source Purist"
    group_label: "Channel Attribution"
    description: "Channel Chameleon versus Single-Source Purist compares a customer's original signup marketing source against the traffic channels of all their subsequent browsing sessions, classifying users into Single-Channel Purists, Bait-and-Switch Channel Hoppers touching two channels, and Omnichannel Everywhere Enthusiasts touching three or more channels (returns NULL for accounts with zero clickstream events). Marketing attribution teams use this classification alongside regional state-by-channel traffic comparisons to show how customers cross between paid, organic, and email touchpoints."
    synonyms: ["attribution chameleon term", "channel chameleon vs single-source purist", "channel chameleon persona", "channel purist vs hopper"]
    case: {
      when: {
        sql: ${TABLE}.user_id IS NOT NULL AND ${distinct_event_sources} < 2 AND ${mismatched_source_events} = 0 ;;
        label: "Single-Channel Purist (1 Channel Only)"
      }
      when: {
        sql: ${TABLE}.user_id IS NOT NULL AND ${distinct_event_sources} < 3 AND (${distinct_event_sources} = 2 OR ${mismatched_source_events} > 0) ;;
        label: "Bait-and-Switch Channel Hopper (2 Channels)"
      }
      when: {
        sql: ${TABLE}.user_id IS NOT NULL AND ${distinct_event_sources} >= 3 ;;
        label: "Omnichannel Everywhere Enthusiast (3+ Channels)"
      }
    }
  }

  measure: avg_channels_touched {
    label: "Average Clickstream Channels Touched"
    description: "Mean number of distinct marketing traffic channels touched across clicking customers."
    synonyms: ["avg channels touched", "average distinct event sources"]
    tags: ["non_additive"]
    type: average
    sql: ${distinct_event_sources} ;;
    value_format_name: decimal_2
  }
}
