view: common_helpers {
  dimension: no_group {
    primary_key: yes
    hidden: yes
    type: number
    sql: 1 ;;
    description: "Synthetic constant grain key used to cancel GROUP BY deduplication on row-level queries."
  }

  dimension_group: current_timestamp {
    hidden: yes
    type: time
    timeframes: [raw, time, date, week, month, quarter, year]
    sql: CURRENT_TIMESTAMP() ;;
    description: "Current warehouse UTC timestamp helper for open-ended duration calculations."
  }
}
