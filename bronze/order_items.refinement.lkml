include: "order_items.view.lkml"

view: +order_items {
  dimension: user_id {
    tags: ["foreign_key"]
  }

  dimension: product_id {
    tags: ["foreign_key"]
  }

  dimension: order_id {
    tags: ["foreign_key"]
  }

  dimension: inventory_item_id {
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

  dimension: is_returned {
    type: yesno
    sql: ${returned_raw} IS NOT NULL ;;
    description: "Whether the order item has a return timestamp recorded (returned_at is populated)."
  }

  dimension: is_ever_returned {
    type: yesno
    hidden: yes
    sql: ${status} = 'Returned' OR ${is_returned} ;;
    description: "Helper flag indicating whether the order item has status 'Returned' or a populated returned_at timestamp."
  }

  dimension: is_reversed {
    label: "Reversed Order Item (Returned or Cancelled)"
    description: "Whether the ordered line item was reversed through cancellation or customer return (status in 'Returned' or 'Cancelled')."
    synonyms: ["is reversed", "returned or cancelled item", "boomerang reversal"]
    type: yesno
    sql: ${status} IN ('Returned', 'Cancelled') ;;
  }

  dimension: created_year_utc {
    label: "Created Calendar Year (UTC)"
    group_label: "Created Date"
    description: "UTC calendar year when the order item was created."
    synonyms: ["order year", "created year utc", "item purchase year"]
    type: number
    value_format_name: id
    sql: EXTRACT(YEAR FROM ${created_raw}) ;;
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

  dimension: created_month_num {
    label: "Created Calendar Month"
    group_label: "Created Date"
    description: "Numeric UTC calendar month when the order item was created (1 = January through 12 = December)."
    synonyms: ["calendar month", "created month number", "order month"]
    type: number
    sql: EXTRACT(MONTH FROM ${created_raw}) ;;
  }

  dimension: retail_seasonal_vintage {
    label: "Retail Seasonal Order Vintage"
    description: "Retail Seasonal Order Vintage groups transactions into five commercial fashion seasons across the calendar year: 'Q4 Cyber-Holiday Frenzy (Nov-Dec)', 'Back-to-School & Fall Layering (Aug-Oct)', 'Spring Wardrobe Reboot (Mar-May)', 'Mid-Summer Fiesta (Jun-Jul)', and 'New-Year Resolution Rush (Jan-Feb)'. Seasonal buyers use these retail vintages to align activewear, swimwear, and winter coat inventory with peak seasonal demand."
    synonyms: ["retail seasonal vintage", "retail seasonal order vintage", "commercial fashion season", "order season vintage"]
    case: {
      when: {
        sql: ${created_month_num} IN (11, 12) ;;
        label: "Q4 Cyber-Holiday Frenzy (Nov-Dec)"
      }
      when: {
        sql: ${created_month_num} IN (8, 9, 10) ;;
        label: "Back-to-School & Fall Layering (Aug-Oct)"
      }
      when: {
        sql: ${created_month_num} IN (3, 4, 5) ;;
        label: "Spring Wardrobe Reboot (Mar-May)"
      }
      when: {
        sql: ${created_month_num} IN (6, 7) ;;
        label: "Mid-Summer Fiesta (Jun-Jul)"
      }
      else: "New-Year Resolution Rush (Jan-Feb)"
    }
  }

  dimension: is_high_roller_single_item {
    label: "High-Roller Single Item"
    description: "High-Roller Single Item identifies any individual order item sold for a hundred dollars or more (sale_price >= 100.0). Merchandising and fulfillment teams use this label to spot premium-ticket purchases that qualify for upgraded packaging and VIP post-purchase follow-up."
    synonyms: ["high roller single item", "high-roller item", "high roller item", "premium-ticket purchase"]
    type: yesno
    sql: ${sale_price} >= 100.0 ;;
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

  dimension: fulfillment_speed_tier {
    label: "Flash-Flood versus Snail-Mail Fulfillment Tier"
    description: "Flash-Flood versus Snail-Mail Fulfillment Tier categorizes every item by total door-to-door wait time from checkout to delivery: 'Supersonic Drone Speed (<24h)', 'Prime-ish Express (24-72h)', 'Standard Pony Express (72-120h)', 'Lost-at-Sea Snail Mail (120h+)', or 'Still Floating in Transit / Unshipped' when undelivered. Customer support teams use this speed tier to monitor delivery service levels and proactively send apology credits when orders fall into the snail-mail bracket."
    synonyms: ["fulfillment speed tier", "flash-flood vs snail-mail tier", "delivery speed tier", "doorstep speed bracket"]
    case: {
      when: {
        sql: ${is_delivered} AND ${hours_total_doorstep_wait} < 24 ;;
        label: "Supersonic Drone Speed (<24h)"
      }
      when: {
        sql: ${is_delivered} AND ${hours_total_doorstep_wait} < 72 ;;
        label: "Prime-ish Express (24-72h)"
      }
      when: {
        sql: ${is_delivered} AND ${hours_total_doorstep_wait} < 120 ;;
        label: "Standard Pony Express (72-120h)"
      }
      when: {
        sql: ${is_delivered} ;;
        label: "Lost-at-Sea Snail Mail (120h+)"
      }
      else: "Still Floating in Transit / Unshipped"
    }
  }

  measure: count {
    label: "Total Impulse Line Items Count"
    description: "Total Impulse Line Items Count tracks the sheer number of individual clothing items customers have tossed into their virtual carts and checked out. Warehouse operations use this volume metric to forecast daily packing workload and estimate how many shipping boxes they need to fold."
    synonyms: ["items sold", "item volume", "items purchased", "total units sold", "units sold", "total items ordered", "items ordered"]
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

  measure: distinct_users {
    label: "Active Buyers"
    description: "Number of distinct customers who purchased at least one order item."
    synonyms: ["active buyers", "distinct buying users", "buying users", "purchasing customers"]
    type: count_distinct
    tags: ["non_additive"]
    sql: ${user_id} ;;
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

  measure: ever_returned_items {
    label: "Boomeranged Items"
    description: "Count of ordered line items that came back as customer returns (status is 'Returned' or returned_at is populated)."
    synonyms: ["boomeranged items", "ever returned items", "boomerang items"]
    type: count
    filters: [is_ever_returned: "yes"]
  }

  measure: ever_returned_revenue {
    label: "Boomeranged Refund Dollars"
    description: "Total sale price of ordered line items returned by customers (status is 'Returned' or returned_at is populated)."
    synonyms: ["returned dollars", "boomeranged refund dollars", "ever returned revenue"]
    type: sum
    sql: ${sale_price} ;;
    filters: [is_ever_returned: "yes"]
    value_format_name: usd
  }

  measure: ever_return_rate {
    label: "Brand Return Boomerang Rate"
    description: "Brand Return Boomerang Rate identifies the share of ordered items that come back as customer returns (status 'Returned' or returned_at populated). Merchandising quality teams review this boomerang leaderboard to flag brands with inconsistent sizing or misleading product photos."
    synonyms: ["boomerang return rate", "boomerang return rate pct", "brand return boomerang rate"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${ever_returned_items} / NULLIF(${count}, 0) ;;
    value_format_name: percent_2
  }

  measure: refunded_revenue {
    label: "Refunded Dollars"
    description: "Total sale price refunded to customers across ordered line items in 'Returned' status."
    synonyms: ["refunded dollars", "total refunded revenue", "returned revenue"]
    type: sum
    sql: ${sale_price} ;;
    filters: [status: "Returned"]
    value_format_name: usd
  }

  measure: returned_items {
    label: "Returned Items"
    description: "Count of ordered line items currently in 'Returned' status."
    synonyms: ["items returned", "returned item count", "returned units"]
    type: count
    filters: [status: "Returned"]
  }

  measure: return_rate {
    label: "Item Return Rate"
    description: "Share of ordered line items currently in 'Returned' status out of total items ordered."
    synonyms: ["return pct", "return percentage", "category return rate"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${returned_items} / NULLIF(${count}, 0) ;;
    value_format_name: percent_2
  }

  measure: completed_items {
    label: "Completed Line Items"
    description: "Count of ordered line items settled in 'Complete' status."
    synonyms: ["clean kept items", "completed items", "complete order items"]
    type: count
    filters: [status: "Complete"]
  }

  measure: recent_era_revenue {
    label: "Recent-Era Revenue (2025+)"
    description: "Gross dollar sales from order line items placed in calendar year 2025 or later (UTC)."
    synonyms: ["recent era rev", "2025 plus revenue", "recent momentum revenue"]
    type: sum
    sql: ${sale_price} ;;
    filters: [created_year_utc: ">=2025"]
    value_format_name: usd
  }

  measure: recent_era_revenue_share {
    label: "Recent-Era Revenue Share (2025+)"
    description: "Share of cumulative all-time gross sales generated in calendar year 2025 or later (recent_era_revenue / total_revenue)."
    synonyms: ["recent era share", "recent momentum share", "recent revenue share"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${recent_era_revenue} / NULLIF(${total_revenue}, 0) ;;
    value_format_name: percent_2
  }

  measure: spend_per_buyer {
    label: "Spend per Active Buyer"
    description: "Average gross dollar spend per distinct purchasing customer across ordered line items (total_revenue / distinct_users)."
    synonyms: ["spend per buyer", "revenue per buyer", "average spend per buyer"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${total_revenue} / NULLIF(${distinct_users}, 0) ;;
    value_format_name: usd
  }

  measure: _sale_price_count {
    hidden: yes
    type: count
    filters: [sale_price: "NOT NULL"]
  }

  measure: _sale_price_sum_of_squares {
    hidden: yes
    type: sum
    sql: POWER(${sale_price}, 2) ;;
  }

  measure: stddev_sale_price {
    label: "Sale Price Standard Deviation"
    description: "Sample standard deviation of ordered item sale prices."
    synonyms: ["sale price stddev", "item sale price spread"]
    tags: ["non_additive"]
    type: number
    value_format_name: usd
    sql: SQRT(GREATEST(${_sale_price_sum_of_squares} - (POWER(${total_revenue}, 2) / NULLIF(${_sale_price_count}, 0)), 0) / NULLIF(${_sale_price_count} - 1, 0)) ;;
  }
}
