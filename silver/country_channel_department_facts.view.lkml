include: "/silver/explores/order_items.explore.lkml"

view: country_channel_department_facts {
  label: "Country Channel-Department Margin Rank Facts"

  derived_table: {
    explore_source: order_items {
      column: country { field: users.country }
      column: traffic_source { field: users.traffic_source }
      column: department { field: products.department }
      column: orders_count { field: order_items.distinct_orders }
      column: items_count { field: order_items.count }
      column: gross_rev { field: order_items.total_revenue }
      column: gross_margin { field: inventory_items_order_items_fields.total_gross_profit }
      column: avg_km { field: distribution_centers_order_items_users_fields.avg_shipment_distance_km }
      filters: [
        orders.order_id: "NOT NULL",
        users.id: "NOT NULL",
        products.id: "NOT NULL",
        inventory_items.id: "NOT NULL",
        distribution_centers.id: "NOT NULL"
      ]
      derived_column: channel_dept_rank_in_country {
        sql: RANK() OVER (PARTITION BY country ORDER BY gross_margin DESC) ;;
      }
    }
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(COALESCE(${country}, ''), '|', COALESCE(${traffic_source}, ''), '|', COALESCE(${department}, '')) ;;
  }

  dimension: country {
    label: "Buyer Country"
    description: "Destination country of purchasing customers."
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: traffic_source {
    label: "Acquisition Traffic Source"
    description: "Customer signup acquisition marketing channel."
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: department {
    label: "Product Department"
    description: "Catalog product department purchased."
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: orders_count {
    label: "Distinct Orders"
    description: "Distinct customer orders placed in the country-channel-department segment."
    type: number
    sql: ${TABLE}.orders_count ;;
  }

  dimension: items_count {
    label: "Items Sold"
    description: "Order line items sold in the country-channel-department segment."
    type: number
    sql: ${TABLE}.items_count ;;
  }

  dimension: gross_rev {
    label: "Gross Revenue"
    description: "Gross dollar sales in the country-channel-department segment."
    type: number
    value_format_name: usd
    sql: ${TABLE}.gross_rev ;;
  }

  dimension: gross_margin {
    label: "Gross Margin Dollars"
    description: "Realized gross profit dollars (sale_price - cost) in the country-channel-department segment."
    type: number
    value_format_name: usd
    sql: ${TABLE}.gross_margin ;;
  }

  dimension: avg_km {
    label: "Average Shipment Distance (km)"
    description: "Mean straight-line shipping distance in kilometers for the country-channel-department segment."
    type: number
    value_format_name: decimal_0
    sql: ${TABLE}.avg_km ;;
  }

  dimension: channel_dept_rank_in_country {
    label: "Channel-Department Rank in Country"
    description: "Competition rank of the (traffic_source, department) combination by gross margin within each country (1 = top gross margin combination in country)."
    type: number
    sql: ${TABLE}.channel_dept_rank_in_country ;;
  }

  measure: count {
    label: "Country-Channel-Department Segments"
    description: "Number of evaluated country, channel, and department combinations."
    type: count
  }

  measure: total_segment_gross_margin {
    label: "Total Segment Gross Margin"
    description: "Cumulative gross margin dollars summed across country-channel-department segments."
    type: sum
    value_format_name: usd
    sql: ${gross_margin} ;;
  }
}
