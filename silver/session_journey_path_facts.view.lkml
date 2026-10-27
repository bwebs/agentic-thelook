include: "/silver/explores/events.explore.lkml"

view: session_journey_path_facts {
  label: "Session Journey Path Facts"

  derived_table: {
    explore_source: events {
      column: click_journey_path { field: browsing_session_facts.click_journey_path }
      column: is_converted_to_purchase { field: browsing_session_facts.is_converted_to_purchase }
      column: session_frequency { field: browsing_session_facts.count }
      derived_column: total_all_sessions {
        sql: SUM(session_frequency) OVER () ;;
      }
    }
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(COALESCE(${click_journey_path}, ''), '|', COALESCE(CAST(${TABLE}.is_converted_to_purchase AS STRING), '')) ;;
  }

  dimension: click_journey_path {
    label: "Clickstream Journey Path"
    description: "Full chronological sequence of page event_type steps (' -> ') visited during the browsing session."
    synonyms: ["click journey path", "session path", "browsing journey"]
    type: string
    sql: ${TABLE}.click_journey_path ;;
  }

  dimension: is_converted_to_purchase {
    label: "Converted Session"
    description: "Whether the browsing session included at least one completed purchase event."
    synonyms: ["converted", "is converted", "purchased in session"]
    type: yesno
    sql: ${TABLE}.is_converted_to_purchase ;;
  }

  dimension: _session_frequency {
    hidden: yes
    type: number
    sql: ${TABLE}.session_frequency ;;
  }

  dimension: _total_all_sessions {
    hidden: yes
    type: number
    sql: ${TABLE}.total_all_sessions ;;
  }

  measure: session_frequency {
    label: "Session Frequency"
    description: "Number of browsing sessions that followed this exact clickstream journey path and conversion outcome."
    synonyms: ["session frequency", "journey session count"]
    type: sum
    sql: ${_session_frequency} ;;
  }

  measure: _all_sessions_denominator {
    hidden: yes
    tags: ["non_additive"]
    type: max
    sql: ${_total_all_sessions} ;;
  }

  measure: share_of_all_sessions {
    label: "Share of All Browsing Sessions"
    description: "Share of all website browsing sessions across the store represented by this journey path."
    synonyms: ["share of all sessions", "share of all sessions pct", "journey session share"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${session_frequency} / NULLIF(${_all_sessions_denominator}, 0) ;;
    value_format_name: percent_2
  }
}
