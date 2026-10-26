include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"

view: user_warehouse_proximity_facts {
  extends: [users]
  label: "Customer Warehouse Proximity Facts"

  derived_table: {
    sql:
      SELECT
        {{ id._sql }} AS id,
        MIN(ST_DISTANCE({{ user_geom._sql }}, {{ _sdt_distribution_centers.distribution_center_geom._sql }}) / 1000.0) AS nearest_dc_km,
        ARRAY_AGG(
          {{ _sdt_distribution_centers.name._sql }}
          ORDER BY ST_DISTANCE({{ user_geom._sql }}, {{ _sdt_distribution_centers.distribution_center_geom._sql }}) ASC
          LIMIT 1
        )[OFFSET(0)] AS nearest_warehouse_name
      FROM ${users.SQL_TABLE_NAME} AS {{ _table }}
      CROSS JOIN ${distribution_centers.SQL_TABLE_NAME} AS {{ _sdt_distribution_centers._name }}
      GROUP BY {{ id._sql }} ;;
  }

  dimension: id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: nearest_dc_km {
    label: "Nearest Warehouse Distance (km)"
    group_label: "Warehouse Proximity & Catchment"
    description: "Straight-line geodesic distance in kilometers from the customer's home coordinates to the closest physical distribution center."
    synonyms: ["nearest dc km", "distance to nearest warehouse km", "catchment distance km"]
    type: number
    value_format_name: decimal_1
    sql: ${TABLE}.nearest_dc_km ;;
  }

  dimension: nearest_warehouse_name {
    label: "Natural Catchment Warehouse"
    group_label: "Warehouse Proximity & Catchment"
    description: "Name of the closest physical fulfillment warehouse to the customer's home coordinates by straight-line geodesic distance."
    synonyms: ["natural catchment warehouse", "nearest warehouse name", "closest distribution center"]
    type: string
    sql: ${TABLE}.nearest_warehouse_name ;;
  }

  dimension: warehouse_proximity_tier {
    label: "Warehouse Local Neighbor versus Long-Haul Buyer"
    group_label: "Warehouse Proximity & Catchment"
    description: "Warehouse Local Neighbor versus Long-Haul Buyer classifies every registered customer by the straight-line distance from their home to our nearest physical distribution center: Forklift Earshot Neighbors (<100 km to Warehouse), Regional Drive Zone (100-500 km), Domestic Air-Freight Zone (500-2,500 km), and Transoceanic Overseas Expeditions (2,500+ km). Fulfillment planners use these proximity tiers and natural warehouse catchment counts to identify which customers live close enough for same-day local courier delivery."
    synonyms: [
      "warehouse proximity tier",
      "warehouse local neighbor vs long-haul buyer",
      "local neighbor versus long-haul buyer",
      "dc proximity tier"
    ]
    case: {
      when: {
        sql: ${nearest_dc_km} < 100.0 ;;
        label: "Forklift Earshot Neighbor (<100 km to Warehouse)"
      }
      when: {
        sql: ${nearest_dc_km} < 500.0 ;;
        label: "Regional Drive Zone (100-500 km)"
      }
      when: {
        sql: ${nearest_dc_km} < 2500.0 ;;
        label: "Domestic Air-Freight Zone (500-2,500 km)"
      }
      else: "Transoceanic Overseas Expedition (2,500+ km)"
    }
  }

  measure: avg_nearest_dc_km {
    label: "Average Distance to Nearest Warehouse (km)"
    description: "Average straight-line distance in kilometers from registered customers to their closest physical fulfillment warehouse."
    synonyms: ["avg km to nearest dc", "avg catchment radius km", "average distance to nearest dc"]
    type: average
    tags: ["non_additive"]
    value_format_name: decimal_1
    sql: ${nearest_dc_km} ;;
  }
}
