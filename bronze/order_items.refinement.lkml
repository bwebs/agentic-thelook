include: "order_items.view.lkml"

view: +order_items {
  measure: total_revenue {
    label: "Total Revenue"
    description: "Overall gross dollar sales across every item ever ordered in the store, before backing out returns, cancellations, or product cost."
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }
}
