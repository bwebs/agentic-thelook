include: "/bronze/explores/events_base.explore.lkml"

view: browsing_session_facts {
  label: "Browsing Session Facts"

  derived_table: {
    explore_source: events_base {
      column: session_id { field: events.session_id }
      column: event_count { field: events.count }
      column: purchase_events { field: events.purchase_events }
    }
  }

  dimension: session_id {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.session_id ;;
  }

  dimension: event_count {
    label: "Session Event Count"
    description: "Total number of clickstream events recorded within the browsing session."
    synonyms: ["total events in session", "session depth", "clicks in session"]
    type: number
    sql: ${TABLE}.event_count ;;
  }

  dimension: is_converted_to_purchase {
    label: "Converted to Purchase"
    description: "Whether the browsing session includes at least one completed purchase event."
    synonyms: ["converted to purchase", "is purchasing session"]
    type: yesno
    sql: ${TABLE}.purchase_events > 0 ;;
  }

  dimension: session_marathon_tier {
    label: "Clickstream Binge-Scroll Marathon Tier"
    description: "Clickstream Binge-Scroll Marathon Tier classifies every browsing session by how many pages the visitor clicked through: 'One-Hit Bounce (1 Event)', 'Casual Window Peek (2-4 Events)', 'Serious Closet Audit (5-9 Events)', and 'Doom-Scroll Fashion Marathon (10+ Events)'. Growth engineers use this engagement tier to separate shallow one-click bounce traffic from deep, high-intent shopping sessions."
    synonyms: ["session marathon tier", "clickstream binge-scroll marathon tier", "binge-scroll marathon tier", "session engagement tier"]
    case: {
      when: {
        sql: ${event_count} = 1 ;;
        label: "One-Hit Bounce (1 Event)"
      }
      when: {
        sql: ${event_count} BETWEEN 2 AND 4 ;;
        label: "Casual Window Peek (2-4 Events)"
      }
      when: {
        sql: ${event_count} BETWEEN 5 AND 9 ;;
        label: "Serious Closet Audit (5-9 Events)"
      }
      else: "Doom-Scroll Fashion Marathon (10+ Events)"
    }
  }

  measure: count {
    label: "Browsing Sessions"
    description: "Total number of distinct browsing sessions."
    synonyms: ["sessions count", "browsing session count"]
    type: count
  }

  measure: converted_sessions {
    label: "Converting Browsing Sessions"
    description: "Number of distinct browsing sessions that converted to at least one purchase event."
    synonyms: ["purchasing sessions", "converted sessions"]
    type: count
    filters: [is_converted_to_purchase: "yes"]
  }

  measure: session_conversion_rate {
    label: "Session Purchase Conversion Rate"
    description: "Share of browsing sessions that completed at least one purchase event (converted_sessions / count)."
    synonyms: ["conversion rate pct", "session conversion rate", "purchase conversion rate"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${converted_sessions} / NULLIF(${count}, 0) ;;
    value_format_name: percent_2
  }
}
