view: state_channel_traffic_dims {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(COALESCE(${users.id}, 0) AS STRING), '_', CAST(COALESCE(${state_events.id}, 0) AS STRING)) ;;
  }

  dimension: us_state {
    label: "Coalesced State"
    description: "Coalesced state or region combining United States customer registration states and clickstream event states."
    synonyms: ["state", "shared state", "coalesced us state"]
    type: string
    sql: COALESCE(${users.us_state}, ${state_events.state}) ;;
  }

  dimension: channel {
    label: "Coalesced Traffic Channel"
    description: "Coalesced marketing traffic channel combining United States customer signup sources and clickstream event traffic sources."
    synonyms: ["traffic source", "shared channel", "marketing channel"]
    type: string
    sql: COALESCE(
      CASE WHEN ${users.us_state} IS NOT NULL THEN ${users.traffic_source} END,
      ${state_events.traffic_source}
    ) ;;
  }

  measure: state_channel_balance_regime {
    label: "State-Channel Registration-to-Click Balance Regime"
    description: "Classifies each state-by-channel combination into 'Hyper-Chatty Clickstream State-Channel' (15+ click events per US registered user), 'Balanced Registration-to-Click State-Channel' (1+ US registered user and <15x clicks), or 'Orphaned Roaming Clicks Only'."
    synonyms: ["state channel balance regime", "registration to click balance", "state traffic regime"]
    tags: ["non_additive"]
    type: string
    sql: CASE
      WHEN COALESCE(${state_events.count}, 0) >= COALESCE(${users.us_registered_users}, 0) * 15 THEN 'Hyper-Chatty Clickstream State-Channel'
      WHEN COALESCE(${users.us_registered_users}, 0) > 0 THEN 'Balanced Registration-to-Click State-Channel'
      ELSE 'Orphaned Roaming Clicks Only'
    END ;;
  }
}
