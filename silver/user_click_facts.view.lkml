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
      column: distinct_ips { field: events.distinct_ip_addresses }
      column: distinct_event_cities { field: events.distinct_cities }
      column: away_from_home_events { field: events_users_fields.away_from_home_events }
      column: distinct_browsers_used { field: events.distinct_browsers }
      column: browser_combo { field: events.browser_combo }
      column: purchase_events { field: events.purchase_events }
      column: first_touch_event_source { field: events.first_touch_event_source }
      column: last_touch_event_source { field: events.last_touch_event_source }
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

  dimension: distinct_ips {
    label: "Distinct Customer IP Addresses"
    group_label: "Nomad Mobility"
    description: "Number of distinct network IP locations recorded across the customer's lifetime clickstream history."
    synonyms: ["distinct ips", "customer ip count", "network locations"]
    type: number
    sql: ${TABLE}.distinct_ips ;;
  }

  dimension: distinct_event_cities {
    label: "Distinct Customer Browsing Cities"
    group_label: "Nomad Mobility"
    description: "Number of distinct cities from which the customer has browsed across their clickstream history."
    synonyms: ["distinct event cities", "browsing cities visited"]
    type: number
    sql: ${TABLE}.distinct_event_cities ;;
  }

  dimension: away_from_home_events {
    label: "Customer Away-from-Home Events"
    group_label: "Nomad Mobility"
    description: "Count of website clickstream events where the customer's browsing city differed from their registered home billing city."
    synonyms: ["user away from home events", "travel browsing events"]
    type: number
    sql: COALESCE(${TABLE}.away_from_home_events, 0) ;;
  }

  dimension: ip_nomad_tier {
    label: "IP Address Nomad Wanderlust Tier"
    group_label: "Nomad Mobility"
    description: "IP Address Nomad Wanderlust Score classifies clicking customers by how many distinct network IP locations they browse from over time into 'Couch Potato (1 IP)', 'Two-Location Commuter (2 IPs)', and 'Road Warrior Nomad (3+ IPs)' (returns NULL for accounts with zero clickstream events). Mobile and travel-retail marketers use this mobility index to understand how often customers shop while commuting or traveling away from home."
    synonyms: ["nomad tier", "ip nomad tier", "ip address nomad wanderlust score", "nomad wanderlust tier"]
    case: {
      when: {
        sql: ${TABLE}.user_id IS NOT NULL AND ${distinct_ips} < 2 ;;
        label: "Couch Potato (1 IP)"
      }
      when: {
        sql: ${TABLE}.user_id IS NOT NULL AND ${distinct_ips} = 2 ;;
        label: "Two-Location Commuter (2 IPs)"
      }
      when: {
        sql: ${TABLE}.user_id IS NOT NULL AND ${distinct_ips} >= 3 ;;
        label: "Road Warrior Nomad (3+ IPs)"
      }
    }
  }

  dimension: distinct_browsers_used {
    label: "Distinct Browsers Used"
    group_label: "Multi-Browser Hopping"
    description: "Number of distinct web browsers the customer has signed in from across their lifetime clickstream history."
    synonyms: ["distinct browsers used", "customer browser count", "browsers hopped"]
    type: number
    sql: ${TABLE}.distinct_browsers_used ;;
  }

  dimension: browser_combo {
    label: "Customer Browser Combination"
    group_label: "Multi-Browser Hopping"
    description: "Plus-delimited alphabetical combination of distinct web browsers used across the customer's lifetime clickstream history."
    synonyms: ["browser combo", "multi-browser combination", "browser stack"]
    type: string
    sql: ${TABLE}.browser_combo ;;
  }

  measure: avg_cities_visited {
    label: "Average Browsing Cities Visited per Clicking User"
    description: "Mean number of distinct browsing cities visited across clicking customers."
    synonyms: ["avg cities visited", "average event cities per user"]
    tags: ["non_additive"]
    type: average
    sql: ${distinct_event_cities} ;;
    value_format_name: decimal_2
  }

  measure: total_user_clicks {
    hidden: yes
    type: sum
    sql: ${total_clicks} ;;
  }

  measure: total_away_from_home_events {
    label: "Total Customer Away-from-Home Events"
    description: "Cumulative away-from-home clickstream events summed across clicking customers."
    synonyms: ["total away from home events"]
    type: sum
    sql: ${away_from_home_events} ;;
  }

  measure: away_from_home_event_share {
    label: "Away-from-Home Browsing Event Share"
    description: "IP Address Nomad Wanderlust Score share of clicking customers' website events generated outside their registered home billing city."
    synonyms: ["away from home event pct", "away from home event share", "nomad wanderlust share"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${total_away_from_home_events} / NULLIF(${total_user_clicks}, 0) ;;
    value_format_name: percent_2
  }

  dimension: purchase_events {
    label: "Customer Clickstream Purchase Events"
    group_label: "Channel Attribution"
    description: "Cumulative checkout purchase clickstream events recorded for the customer (returns NULL when the customer has zero recorded clickstream events)."
    synonyms: ["click purchases", "clickstream purchase events", "user purchase clicks"]
    type: number
    sql: ${TABLE}.purchase_events ;;
  }

  dimension: first_touch_event_source {
    label: "First-Touch Session Traffic Source"
    group_label: "Channel Attribution"
    description: "Session marketing traffic source recorded on the customer's earliest website clickstream event."
    synonyms: ["first touch event source", "earliest clickstream channel"]
    type: string
    sql: ${TABLE}.first_touch_event_source ;;
  }

  dimension: last_touch_event_source {
    label: "Last-Touch Session Traffic Source"
    group_label: "Channel Attribution"
    description: "Session marketing traffic source recorded on the customer's most recent website clickstream event."
    synonyms: ["last touch event source", "latest clickstream channel"]
    type: string
    sql: ${TABLE}.last_touch_event_source ;;
  }

  measure: total_purchase_events {
    label: "Total Customer Clickstream Purchase Events"
    description: "Total clickstream purchase events summed across clicking customers."
    synonyms: ["total click purchases", "sum clickstream purchase events"]
    type: sum
    sql: ${purchase_events} ;;
  }
}
