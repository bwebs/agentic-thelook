include: "/silver/explores/order_items.explore.lkml"

view: user_purchase_recency_facts {
  label: "Customer Purchase Recency Base Facts"

  derived_table: {
    explore_source: order_items {
      column: user_id { field: order_items.user_id }
      column: frequency_orders { field: order_items.distinct_orders }
      column: total_items { field: order_items.count }
      column: gross_monetary { field: order_items.total_revenue }
      column: net_margin_monetary { field: inventory_items_order_items_fields.total_gross_profit }
      column: last_purchase_micros { field: order_items._last_purchase_micros }
      column: returned_items { field: order_items.returned_items }
      column: total_clicks { field: user_click_facts.total_clicks }
      filters: [
        order_items.user_id: "NOT NULL",
        inventory_items.id: "NOT NULL",
        users.id: "NOT NULL"
      ]
      derived_column: dataset_max_purchase_micros {
        sql: MAX(last_purchase_micros) OVER () ;;
      }
    }
  }

  dimension: user_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: recency_days {
    type: number
    sql: TIMESTAMP_DIFF(TIMESTAMP_MICROS(${TABLE}.dataset_max_purchase_micros), TIMESTAMP_MICROS(${TABLE}.last_purchase_micros), DAY) ;;
  }

  dimension: frequency_orders {
    type: number
    sql: ${TABLE}.frequency_orders ;;
  }

  dimension: total_items {
    type: number
    sql: ${TABLE}.total_items ;;
  }

  dimension: gross_monetary {
    type: number
    sql: ${TABLE}.gross_monetary ;;
  }

  dimension: net_margin_monetary {
    type: number
    sql: ${TABLE}.net_margin_monetary ;;
  }

  dimension: returned_items {
    type: number
    sql: ${TABLE}.returned_items ;;
  }

  dimension: total_clicks {
    type: number
    sql: COALESCE(${TABLE}.total_clicks, 0) ;;
  }
}
