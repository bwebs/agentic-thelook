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

  dimension: net_margin_ratio {
    label: "Item Gross Margin Ratio"
    description: "Item-level gross profit margin ratio calculated as (sale_price - cost) divided by sale_price."
    synonyms: ["item margin ratio", "line item margin pct", "net margin pct"]
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${gross_profit}, ${order_items.sale_price}) ;;
  }

  dimension: chaos_adjusted_item_profit {
    label: "Chaos-Adjusted Net Profit (Item)"
    description: "Item-level net profit after charging a 15% wholesale cost restocking penalty on Returned or Cancelled items (sale_price - cost when kept, else -0.15 * cost)."
    synonyms: ["friction adjusted item profit", "restocking penalized item profit"]
    type: number
    value_format_name: usd
    sql: CASE WHEN NOT ${order_items.is_reversed} THEN ${order_items.sale_price} - ${inventory_items.cost} ELSE -0.15 * ${inventory_items.cost} END ;;
  }

  dimension: imputed_shelf_dwell_days {
    hidden: yes
    type: number
    sql: COALESCE(${inventory_items.shelf_turn_days}, 30.0) ;;
  }

  measure: total_cogs {
    label: "Total Wholesale COGS"
    description: "Total wholesale inventory cost of goods sold summed across ordered line items."
    synonyms: ["total cogs", "wholesale inventory cogs", "cost of goods sold"]
    type: sum
    value_format_name: usd
    sql: ${inventory_items.cost} ;;
  }

  measure: total_gross_profit {
    label: "Total Gross Profit"
    description: "Realized gross dollar profit across ordered line items after subtracting wholesale inventory cost from checkout sale price (SUM(sale_price - cost))."
    synonyms: ["total profit", "net profit", "group profit", "sku profit", "gross margin", "realized gross profit", "department profit"]
    type: sum
    value_format_name: usd
    sql: ${gross_profit} ;;
  }

  measure: avg_gross_profit {
    label: "Average Unit Gross Profit"
    description: "Mean realized gross dollar profit per ordered line item (AVG(sale_price - cost))."
    synonyms: ["profit per unit", "avg net margin", "average unit profit", "unit realized profit"]
    tags: ["non_additive"]
    type: average
    value_format_name: usd
    sql: ${gross_profit} ;;
  }

  measure: retained_net_profit {
    label: "Retained Net Profit"
    description: "Net dollar profit retained across non-reversed order line items (excluding Returned and Cancelled transactions)."
    synonyms: ["retained profit", "retained channel profit", "kept net profit"]
    type: sum
    value_format_name: usd
    sql: ${gross_profit} ;;
    filters: [order_items.is_reversed: "no"]
  }

  measure: gross_margin_ratio {
    label: "Gross Profit Margin"
    description: "Realized gross profit margin share across ordered line items, calculated as total gross profit divided by total gross revenue."
    synonyms: ["gross margin", "blended margin", "blended margin pct", "margin pct", "gross profit margin share", "realized margin pct", "realized gross margin"]
    tags: ["non_additive"]
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${total_gross_profit} / NULLIF(${order_items.total_revenue}, 0) ;;
  }

  measure: avg_order_shelf_age_days {
    label: "Average Order Shelf Age (Days, Zero-Defaulted)"
    description: "Average whole days ordered inventory sat on the shelf prior to sale across transaction items (counting unrecorded sale timestamps as 0 days)."
    synonyms: ["avg shelf age days", "average transaction shelf age days"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_0
    sql: COALESCE(${inventory_items.days_on_shelf}, 0) ;;
  }

  measure: chaos_adjusted_net_profit {
    label: "Chaos-Adjusted Net Profit"
    description: "Total net dollar profit across ordered items after subtracting wholesale COGS on kept items and a 15% wholesale restocking loss on Returned or Cancelled items."
    synonyms: ["chaos adjusted net profit", "restocking-adjusted net profit"]
    type: sum
    value_format_name: usd
    sql: ${chaos_adjusted_item_profit} ;;
  }

  measure: avg_imputed_shelf_dwell_days {
    label: "Average Imputed Shelf Dwell Days"
    description: "Mean fractional days (hours / 24.0) ordered inventory sat on warehouse shelves prior to sale, imputing 30.0 days when sale timestamps are unrecorded."
    synonyms: ["avg shelf dwell days", "imputed shelf dwell days"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_1
    sql: ${imputed_shelf_dwell_days} ;;
  }
}
