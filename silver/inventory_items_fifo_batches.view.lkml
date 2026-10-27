include: "/bronze/inventory_items.view.lkml"
include: "/bronze/inventory_items.refinement.lkml"

view: inventory_items_fifo_batches {
  extends: [inventory_items]
  label: "Inventory SKU-Warehouse FIFO Batches"

  derived_table: {
    sql:
      SELECT
        {{ id._sql }} AS id,
        MIN(CASE WHEN {{ sold_raw._sql }} IS NULL THEN {{ created_raw._sql }} END) OVER (
          PARTITION BY {{ product_id._sql }}, {{ product_distribution_center_id._sql }}
        ) AS oldest_unsold_stocked_at,
        COUNT({{ id._sql }}) OVER (
          PARTITION BY {{ product_id._sql }}, {{ product_distribution_center_id._sql }}
        ) AS total_sku_units_at_dc
      FROM ${inventory_items.SQL_TABLE_NAME} AS {{ _table }} ;;
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: oldest_unsold_stocked {
    label: "Oldest Unsold Batch Stocked"
    description: "Earliest intake timestamp among remaining unsold units of the same product SKU inside the same distribution center."
    type: time
    timeframes: [raw, time, date]
    sql: ${TABLE}.oldest_unsold_stocked_at ;;
  }

  dimension: total_sku_units_at_dc {
    label: "Total SKU Units at Warehouse"
    description: "Total physical units of the same product SKU stocked at the same distribution center."
    synonyms: ["total sku units at dc", "warehouse sku batch units"]
    type: number
    sql: ${TABLE}.total_sku_units_at_dc ;;
  }
}
