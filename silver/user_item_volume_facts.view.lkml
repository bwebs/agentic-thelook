include: "/bronze/explores/order_items_base.explore.lkml"

view: user_item_volume_facts {
  label: "Customer Item Volume Facts"

  derived_table: {
    explore_source: order_items_base {
      column: user_id { field: order_items.user_id }
      column: buyer_lifetime_items { field: order_items.count }
      filters: [order_items.user_id: "NOT NULL"]
    }
  }

  dimension: user_id {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: buyer_lifetime_items {
    label: "Buyer Lifetime Line Items"
    description: "Cumulative number of order line items purchased across the customer's order history."
    synonyms: ["buyer lifetime items", "user total order items"]
    type: number
    sql: COALESCE(${TABLE}.buyer_lifetime_items, 0) ;;
  }
}
