view: inventory_items_order_items_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${order_items.id} ;;
  }

  dimension: gross_profit {
    label: "Item Gross Profit"
    description: "Item-level gross dollar profit calculated as order item sale price minus physical inventory unit wholesale cost (sale_price - cost)."
    synonyms: ["item profit", "unit gross profit", "line item net profit"]
    type: number
    value_format_name: usd
    sql: ${order_items.sale_price} - ${inventory_items.cost} ;;
  }

  measure: total_gross_profit {
    label: "Total Gross Profit"
    description: "Total gross dollar profit across ordered line items (sum of sale_price minus inventory wholesale cost)."
    synonyms: ["total profit", "net profit", "group profit", "sku profit"]
    type: sum
    value_format_name: usd
    sql: ${gross_profit} ;;
  }

  measure: gross_margin_ratio {
    label: "Gross Profit Margin"
    description: "Blended gross profit margin share across ordered line items, calculated as total gross profit divided by total gross revenue."
    synonyms: ["gross margin", "blended margin", "blended margin pct", "margin pct", "gross profit margin share"]
    tags: ["non_additive"]
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_gross_profit} / NULLIF(${order_items.total_revenue}, 0) ;;
  }
}
