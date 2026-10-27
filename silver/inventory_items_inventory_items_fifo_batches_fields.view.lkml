view: inventory_items_inventory_items_fifo_batches_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${inventory_items.id} ;;
  }

  dimension: is_fifo_line_cutter_shipment {
    label: "FIFO Line-Cutter Shipment"
    description: "Whether a sold inventory unit was stocked after an older identical SKU unit at the same fulfillment center that is still sitting unsold on the shelf."
    synonyms: ["is fifo line cutter", "fifo violation shipment", "out-of-order fifo unit"]
    type: yesno
    sql: ${inventory_items.is_sold}
      AND ${inventory_items_fifo_batches.oldest_unsold_stocked_raw} IS NOT NULL
      AND ${inventory_items.created_raw} > ${inventory_items_fifo_batches.oldest_unsold_stocked_raw} ;;
  }

  dimension_group: older_unit_skipped {
    label: "Older Unsold Unit Skipped Age"
    description: "Elapsed whole days between the intake timestamp of the oldest remaining unsold unit of the same SKU at the warehouse and the shipped unit's intake timestamp."
    type: duration
    intervals: [day]
    sql_start: ${inventory_items_fifo_batches.oldest_unsold_stocked_raw} ;;
    sql_end: ${inventory_items.created_raw} ;;
  }

  measure: fifo_line_cutter_shipments {
    label: "FIFO Line-Cutter Shipments"
    description: "Count of sold inventory units shipped from newer batches while an older identical unit at the same fulfillment center remained unsold."
    synonyms: ["fifo line cutter shipments", "fifo violation shipments", "skipped-stock shipments"]
    type: count
    filters: [is_fifo_line_cutter_shipment: "yes"]
  }

  measure: fifo_violation_rate {
    label: "Warehouse FIFO Aging Anomaly Score (Violation Rate)"
    description: "Warehouse First-In-First-Out Aging Anomaly Score detects how often a fulfillment center ships out a freshly stocked unit of a product while an older identical unit of that exact same item is left sitting unsold on the shelf (fifo_line_cutter_shipments / sold_units). Warehouse operations auditors use this violation rate to make sure floor teams rotate stock properly instead of just grabbing whichever box was unloaded most recently."
    synonyms: ["fifo violation rate", "fifo violation rate pct", "warehouse first-in-first-out aging anomaly score", "fifo aging anomaly score"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${fifo_line_cutter_shipments} / NULLIF(${inventory_items.sold_units}, 0) ;;
    value_format_name: percent_2
  }

  measure: avg_days_older_unit_skipped {
    label: "Average Days Older Unit Was Skipped"
    description: "Average whole days by which shipped FIFO line-cutter units were stocked after the oldest remaining unsold unit of the same SKU at the same warehouse."
    synonyms: ["avg days older unit was skipped", "average fifo skip days"]
    tags: ["non_additive"]
    type: average
    sql: ${days_older_unit_skipped} ;;
    filters: [is_fifo_line_cutter_shipment: "yes"]
    value_format_name: decimal_1
  }
}
