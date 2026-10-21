include: "products.view.lkml"

view: +products {
  measure: avg_sticker_price {
    label: "Average Sticker Shock"
    description: "Average Sticker Shock measures the simple average retail sticker price across every item in our product catalog, regardless of how often it sells. The merchandising team uses this benchmark in board meetings to position the store as an affordable luxury destination."
    type: average
    sql: ${retail_price} ;;
    value_format_name: usd
  }
}
