include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"

view: logistics_network_nodes {
  extends: [distribution_centers]
  label: "Logistics Network Nodes"

  derived_table: {
    sql:
      SELECT
        'warehouse' AS node_type,
        {{ name._sql }} AS name,
        ROUND({{ latitude._sql }}, 2) AS latitude,
        ROUND({{ longitude._sql }}, 2) AS longitude
      FROM ${distribution_centers.SQL_TABLE_NAME} AS {{ _table }}
      UNION ALL
      SELECT
        'metro_cluster' AS node_type,
        CONCAT({{ _sdt_users.city._sql }}, ', ', {{ _sdt_users.state._sql }}) AS name,
        ROUND(AVG({{ _sdt_users.latitude._sql }}), 2) AS latitude,
        ROUND(AVG({{ _sdt_users.longitude._sql }}), 2) AS longitude
      FROM ${users.SQL_TABLE_NAME} AS {{ _sdt_users._name }}
      WHERE {{ _sdt_users.country._sql }} = 'United States'
      GROUP BY {{ _sdt_users.city._sql }}, {{ _sdt_users.state._sql }}
      HAVING COUNT({{ _sdt_users.id._sql }}) >= 150 ;;
  }

  dimension: compound_pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.node_type, '_', ${name}) ;;
  }

  dimension: id {
    primary_key: no
    hidden: yes
    type: number
    sql: NULL ;;
  }

  dimension: network_node_type {
    label: "Network Node Type"
    description: "Distinguishes 'Physical Warehouse Hub' fulfillment centers from 'High-Density Customer Metro Cluster' US cities with at least 150 registered shoppers."
    synonyms: ["node type", "logistics node type", "warehouse vs metro cluster"]
    case: {
      when: {
        sql: ${TABLE}.node_type = 'warehouse' ;;
        label: "Physical Warehouse Hub"
      }
      else: "High-Density Customer Metro Cluster"
    }
  }

  dimension: name {
    label: "Network Node Name"
    description: "Name of the physical fulfillment center or high-density US customer metro cluster ('City, State')."
    synonyms: ["node name", "warehouse or metro name", "hub or cluster name"]
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: latitude {
    label: "Latitude"
    description: "Geographic latitude rounded to two decimal places (exact warehouse latitude or mean metro customer latitude)."
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    label: "Longitude"
    description: "Geographic longitude rounded to two decimal places (exact warehouse longitude or mean metro customer longitude)."
    type: number
    value_format_name: decimal_2
    sql: ${TABLE}.longitude ;;
  }

  measure: count {
    label: "Network Node Count"
    description: "Total count of logistics network nodes across physical fulfillment centers and high-density US customer metro clusters."
    synonyms: ["node count", "network nodes"]
  }
}
