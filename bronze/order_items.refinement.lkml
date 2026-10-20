include: "order_items.view.lkml"

view: +order_items {
  measure: total_revenue {
    label: "Total Revenue"
    description: "Overall gross dollar sales across every item ever ordered in the store, before backing out returns, cancellations, or product cost."
    type: sum
    sql: ${sale_price} ;;
    value_format_name: usd
  }

  measure: total_line_items_sold {
    label: "Total Impulse Line Items Count"
    description: "Sheer number of individual clothing items customers have tossed into their virtual carts and checked out. Warehouse operations use this volume metric to forecast daily packing workload and estimate how many shipping boxes they need to fold."
    type: count
    drill_fields: [id]
  }
}
