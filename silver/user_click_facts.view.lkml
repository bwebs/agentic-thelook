include: "/silver/explores/events.explore.lkml"

view: user_click_facts {
  label: "Customer Clickstream Facts"

  derived_table: {
    explore_source: events {
      column: user_id { field: events.user_id }
      column: total_clicks { field: events.count }
      column: lifetime_sessions { field: events.unique_chaotic_sessions }
      column: avg_url_depth { field: events.avg_url_path_depth }
      column: cart_events { field: events.cart_events }
      column: cancel_events { field: events.cancel_events }
      column: latest_browser { field: events.latest_browser }
      column: distinct_event_sources { field: events.distinct_traffic_sources }
      column: mismatched_source_events { field: events_users_fields.channel_crossover_events }
      filters: [events.user_id: "NOT NULL"]
    }
  }

  dimension: user_id {
    primary_key: yes
    label: "Clicking Customer User ID"
    description: "Unique customer identifier for shoppers who have generated at least one recorded clickstream event."
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

  dimension: lifetime_sessions {
    label: "Customer Lifetime Sessions"
    group_label: "Clickstream Friction & Load"
    description: "Cumulative distinct browsing sessions recorded across the customer's clickstream history."
    synonyms: ["sessions cnt", "user sessions", "customer session count"]
    type: number
    sql: ${TABLE}.lifetime_sessions ;;
  }

  dimension: avg_url_depth {
    label: "Customer Average URL Depth"
    group_label: "Clickstream Friction & Load"
    description: "Mean URL directory path depth across all pages visited by the customer."
    synonyms: ["avg uri depth", "user avg url depth"]
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.avg_url_depth ;;
  }

  dimension: cart_events {
    label: "Customer Cart Events"
    group_label: "Clickstream Friction & Load"
    description: "Cumulative add-to-cart clickstream events recorded for the customer."
    synonyms: ["user cart clicks", "customer cart count"]
    type: number
    sql: COALESCE(${TABLE}.cart_events, 0) ;;
  }

  dimension: cancel_events {
    label: "Customer Cancel Events"
    group_label: "Clickstream Friction & Load"
    description: "Cumulative checkout or browsing cancel clickstream events recorded for the customer."
    synonyms: ["user cancel clicks", "customer cancel count"]
    type: number
    sql: COALESCE(${TABLE}.cancel_events, 0) ;;
  }

  dimension: latest_browser {
    label: "Customer Latest Browser"
    group_label: "Clickstream Friction & Load"
    description: "Browser recorded on the customer's most recent website clickstream event."
    synonyms: ["primary user browser", "most recent customer browser"]
    type: string
    sql: ${TABLE}.latest_browser ;;
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

  measure: avg_user_sessions {
    label: "Average Browsing Sessions per Clicking User"
    description: "Mean number of distinct browsing sessions recorded across clicking customers."
    synonyms: ["avg sessions", "average sessions per customer"]
    tags: ["non_additive"]
    type: average
    sql: ${lifetime_sessions} ;;
    value_format_name: decimal_2
  }

  measure: avg_user_url_depth {
    label: "Average URL Depth per Clicking User"
    description: "Mean per-customer average URL path depth across clicking customers."
    synonyms: ["avg url depth", "average customer url depth"]
    tags: ["non_additive"]
    type: average
    sql: ${avg_url_depth} ;;
    value_format_name: decimal_2
  }
}
