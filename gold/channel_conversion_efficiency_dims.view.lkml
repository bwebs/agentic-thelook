view: channel_conversion_efficiency_dims {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(COALESCE(${users.id}, 0) AS STRING), '_', CAST(COALESCE(${channel_events.id}, 0) AS STRING)) ;;
  }

  filter: cohort_date_filter {
    label: "Activity Cohort Date Window"
    description: "UTC date range scoping both annual customer signups and clickstream purchase events."
    type: date
    convert_tz: no
  }

  dimension: calendar_year {
    label: "Activity Calendar Year (UTC)"
    description: "Coalesced UTC calendar year combining customer account signup year and clickstream purchase event year."
    synonyms: ["calendar year", "activity year", "annual channel year"]
    type: number
    value_format_name: id
    sql: COALESCE(
      ${users.cohort_signup_year},
      CASE WHEN ${channel_events.event_type} = 'purchase' THEN EXTRACT(YEAR FROM ${channel_events.created_raw}) END
    ) ;;
  }

  dimension: channel {
    label: "Coalesced Acquisition & Event Channel"
    description: "Coalesced marketing traffic source combining customer signup traffic_source and clickstream purchase event traffic_source."
    synonyms: ["channel", "traffic source", "acquisition channel"]
    type: string
    sql: COALESCE(
      ${users.traffic_source},
      CASE WHEN ${channel_events.event_type} = 'purchase' THEN ${channel_events.traffic_source} END
    ) ;;
  }

  measure: purchases_to_signups_ratio {
    label: "Clickstream Purchases-to-Signups Ratio"
    description: "Annual ratio of completed clickstream purchase events to newly signed-up customer accounts across shared calendar year and channel."
    synonyms: ["purchases to signups ratio", "annual purchase to signup ratio"]
    tags: ["non_additive"]
    type: number
    value_format_name: decimal_3
    sql: SAFE_DIVIDE(1.0 * COALESCE(${channel_events.purchase_events}, 0), COALESCE(${users.count}, 0)) ;;
  }
}
