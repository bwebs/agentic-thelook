include: "/bronze/explores/events_base.explore.lkml"

view: browsing_session_facts {
  label: "Browsing Session Facts"

  derived_table: {
    explore_source: events_base {
      column: session_id { field: events.session_id }
      column: event_count { field: events.count }
      column: purchase_events { field: events.purchase_events }
      column: cart_events { field: events.cart_events }
      column: cancel_events { field: events.cancel_events }
      column: product_events { field: events.product_events }
      column: department_events { field: events.department_events }
      column: home_events { field: events.home_events }
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

  dimension: has_cancel_event {
    label: "Has Cancel Event"
    description: "Whether the browsing session includes at least one explicit cancel event."
    synonyms: ["had cancel", "is cancel session"]
    type: yesno
    sql: ${TABLE}.cancel_events > 0 ;;
  }

  dimension: is_silent_cart_abandon {
    hidden: yes
    description: "Whether the browsing session added to cart and left quietly without purchasing or hitting cancel."
    type: yesno
    sql: ${TABLE}.purchase_events = 0 AND ${TABLE}.cancel_events = 0 AND ${TABLE}.cart_events > 0 ;;
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

  dimension: session_funnel_archetype {
    label: "Clickstream Cart-Abandoner versus Decisive Closer Session Archetype"
    description: "Clickstream Cart-Abandoner versus Decisive Closer Session Archetype categorizes every website visit by how far down the funnel it progressed: Decisive Closers who completed a purchase, Cold-Feet Cart Abandoners who loaded a cart and left quietly, Dramatic Rage-Cancellers who hit cancel, Window-Only Catalog Browsers, and Front-Door Lobby Bounces. Checkout product managers use these five session archetypes to size the recoverable revenue sitting in abandoned carts."
    synonyms: ["session funnel archetype", "clickstream cart-abandoner vs decisive closer", "cart abandoner archetype", "checkout funnel session tier"]
    case: {
      when: {
        sql: ${TABLE}.purchase_events > 0 ;;
        label: "Decisive Closer Session (Reached Purchase)"
      }
      when: {
        sql: ${is_silent_cart_abandon} ;;
        label: "Cold-Feet Cart Abandoner (Added to Cart, Left Quietly)"
      }
      when: {
        sql: ${TABLE}.cancel_events > 0 ;;
        label: "Dramatic Rage-Canceller Session (Hit Cancel)"
      }
      when: {
        sql: ${TABLE}.product_events > 0 OR ${TABLE}.department_events > 0 ;;
        label: "Window-Only Catalog Browser (No Cart)"
      }
      else: "Front-Door Lobby Bounce (Home Page Only)"
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
    synonyms: ["purchasing sessions", "converted sessions", "completed purchase sessions"]
    type: count
    filters: [is_converted_to_purchase: "yes"]
  }

  measure: silent_cart_abandon_sessions {
    label: "Silent Cart Abandon Sessions"
    description: "Number of distinct browsing sessions where shoppers added to cart and left quietly without purchasing or hitting cancel."
    synonyms: ["cold-feet cart abandon sessions", "silent abandon sessions"]
    type: count
    filters: [is_silent_cart_abandon: "yes"]
  }

  measure: explicit_cancel_sessions {
    label: "Explicit Cancel Sessions"
    description: "Number of distinct browsing sessions containing at least one explicit cancel event."
    synonyms: ["rage cancel sessions", "cancelled browsing sessions"]
    type: count
    filters: [has_cancel_event: "yes"]
  }

  measure: avg_events_per_session {
    label: "Average Events in Session"
    description: "Mean number of clickstream events recorded per distinct browsing session."
    synonyms: ["avg events in session", "average session depth"]
    tags: ["non_additive"]
    type: average
    sql: ${event_count} ;;
    value_format_name: decimal_2
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
