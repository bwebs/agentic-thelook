view: order_items_user_click_facts_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${order_items.id} ;;
  }

  measure: avg_item_buyer_clicks {
    label: "Average Buyer Clicks (Item-Weighted)"
    description: "Mean cumulative website clicks of the purchasing customer weighted across ordered transaction items (counting zero-click buyers as 0)."
    synonyms: ["avg buyer clicks", "transaction avg buyer clicks"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_1
    sql: COALESCE(${user_click_facts.total_clicks}, 0) ;;
  }
}
