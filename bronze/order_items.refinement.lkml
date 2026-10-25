include: "order_items.view.lkml"

view: +order_items {
  dimension: user_id {
    tags: ["foreign_key"]
  }

  dimension: is_shipped {
    type: yesno
    sql: ${shipped_raw} IS NOT NULL ;;
    description: "Whether the order item has been handed to a shipping carrier (shipped_at is populated)."
  }

  dimension: is_delivered {
    type: yesno
    sql: ${delivered_raw} IS NOT NULL ;;
    description: "Whether the order item has been delivered to the customer (delivered_at is populated)."
  }

  dimension: created_day_of_week_num {
    label: "Created Day of Week Number"
    group_label: "Created Date"
    description: "Numeric day of the week when the order item was created in UTC (1 = Sunday through 7 = Saturday)."
    synonyms: ["day of week num", "day of week number"]
    type: number
    sql: EXTRACT(DAYOFWEEK FROM ${created_raw}) ;;
  }

  dimension: shopping_regime {
    label: "Shopping Regime"
    group_label: "Created Date"
    description: "Classifies order items into Saturday and Sunday weekend orders ('Weekend Warrior') versus Monday through Friday weekday orders ('Weekday Grinder')."
    synonyms: ["weekend warrior regime", "weekend vs weekday"]
    type: string
    sql: CASE WHEN ${created_day_of_week_num} IN (1, 7) THEN 'Weekend Warrior' ELSE 'Weekday Grinder' END ;;
  }

  dimension: created_hour_utc {
    label: "Created Hour (UTC)"
    group_label: "Created Date"
    description: "UTC hour of the day when the order item was created (0 = midnight through 23 = 11 PM)."
    synonyms: ["utc hour", "hour of day"]
    type: number
    sql: EXTRACT(HOUR FROM ${created_raw}) ;;
  }

  dimension_group: to_ship {
    label: "To Ship"
    description: "Elapsed time an order sits waiting inside the warehouse before being handed to a shipping carrier (created_at to shipped_at)."
    type: duration
    intervals: [minute, hour, day]
    sql_start: ${created_raw} ;;
    sql_end: ${shipped_raw} ;;
  }

  dimension_group: to_deliver {
    label: "To Deliver"
    description: "Elapsed transit time an order spends riding on delivery trucks from carrier handoff to doorstep delivery (shipped_at to delivered_at)."
    type: duration
    intervals: [minute, hour, day]
    sql_start: ${shipped_raw} ;;
    sql_end: ${delivered_raw} ;;
  }

  dimension_group: total_doorstep_wait {
    label: "Total Doorstep Wait"
    description: "Total elapsed doorstep wait time from order creation to customer delivery (created_at to delivered_at)."
    type: duration
    intervals: [minute, hour, day]
    sql_start: ${created_raw} ;;
    sql_end: ${delivered_raw} ;;
  }

  measure: count {
    label: "Total Impulse Line Items Count"
    description: "Total Impulse Line Items Count tracks the sheer number of individual clothing items customers have tossed into their virtual carts and checked out. Warehouse operations use this volume metric to forecast daily packing workload and estimate how many shipping boxes they need to fold."
    synonyms: ["items sold", "item volume", "items purchased"]
  }

  measure: total_revenue {
    label: "Total Revenue"
    description: "Overall gross dollar sales across every item ever ordered in the store, before backing out returns, cancellations, or product cost."
    synonyms: ["channel revenue"]
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: avg_warehouse_procrastination_hours {
    label: "Average Warehouse Procrastination (Whole Hours)"
    description: "Average integer hours an order sits waiting inside the warehouse before being handed to a shipping carrier (TIMESTAMP_DIFF in HOUR)."
    synonyms: ["average warehouse procrastination hours", "warehouse procrastination hours"]
    type: average
    sql: ${hours_to_ship} ;;
    value_format_name: decimal_2
  }

  measure: avg_truck_transit_hours {
    label: "Average Truck Transit (Whole Hours)"
    description: "Average integer hours an order spends riding on delivery trucks from shipment to delivery (TIMESTAMP_DIFF in HOUR)."
    synonyms: ["average truck transit hours", "truck transit hours"]
    type: average
    sql: ${hours_to_deliver} ;;
    value_format_name: decimal_2
  }

  measure: avg_total_doorstep_wait_hours {
    label: "Average Total Doorstep Wait (Whole Hours)"
    description: "Average total integer hours from order creation to doorstep delivery (TIMESTAMP_DIFF in HOUR)."
    synonyms: ["average total doorstep wait hours", "total doorstep wait hours"]
    type: average
    sql: ${hours_total_doorstep_wait} ;;
    value_format_name: decimal_2
  }

  measure: avg_hours_to_ship {
    label: "Average Hours to Ship"
    description: "Average fractional hours (from minutes) an order sits in the warehouse before being handed to a carrier."
    synonyms: ["average hours to ship"]
    type: average
    sql: ${minutes_to_ship} / 60.0 ;;
    value_format_name: decimal_2
  }

  measure: avg_hours_to_deliver {
    label: "Average Hours to Deliver"
    description: "Average fractional hours (from minutes) an order spends in carrier transit from shipment to delivery."
    synonyms: ["average hours to deliver"]
    type: average
    sql: ${minutes_to_deliver} / 60.0 ;;
    value_format_name: decimal_2
  }

  measure: avg_item_price {
    label: "Average Item Price"
    description: "Mean sale price per ordered item across line items."
    synonyms: ["average sale price", "avg sale price"]
    type: average
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: distinct_orders {
    label: "Distinct Orders"
    description: "Number of unique customer orders represented across order line items."
    synonyms: ["order count", "unique orders"]
    type: count_distinct
    sql: ${order_id} ;;
  }

  measure: late_night_revenue {
    label: "Midnight Owl Revenue"
    description: "Gross dollar sales from order items placed during late-night hours between midnight and 6:00 AM UTC (hours 0–5)."
    synonyms: ["midnight owl revenue", "overnight revenue"]
    type: sum
    sql: ${sale_price} ;;
    filters: [created_hour_utc: "[0, 5]"]
    value_format_name: usd
  }

  measure: late_night_revenue_share {
    label: "Midnight Owl Impulse Spend Share"
    description: "Midnight Owl Impulse Spend Share calculates the share of store sales generated in the late-night hours between midnight and six in the morning (hours 0–5 UTC). Lifecycle marketers use this late-night impulse index to schedule overnight push notifications and flash promos for night owls."
    synonyms: ["midnight owl revenue pct", "midnight owl spend share", "late night impulse index"]
    type: number
    sql: 1.0 * ${late_night_revenue} / NULLIF(${total_revenue}, 0) ;;
    value_format_name: percent_2
  }
}
