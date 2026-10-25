view: order_items_products_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${order_items.id} ;;
  }

  measure: sock_units_sold {
    label: "Socks & Hosiery Units Sold"
    description: "Total order line item units sold across products in the 'Socks' and 'Socks & Hosiery' categories."
    synonyms: ["sock units sold", "socks and hosiery units sold"]
    type: count
    filters: [products.category: "Socks,Socks & Hosiery"]
  }

  measure: sock_unit_share {
    label: "Socks & Hosiery Unit Share"
    description: "Socks and Hosiery Obsession Index (Unit Share) calculates the share of all units sold that comes specifically from customers buying socks and hosiery across men's and women's lines."
    synonyms: ["sock unit share pct", "socks and hosiery obsession index", "socks unit share"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${sock_units_sold} / NULLIF(${order_items.count}, 0) ;;
    value_format_name: percent_2
  }

  measure: total_sock_revenue {
    label: "Total Socks & Hosiery Revenue"
    description: "Gross dollar sales from order line items in the 'Socks' and 'Socks & Hosiery' product categories."
    synonyms: ["total sock revenue", "sock revenue", "socks and hosiery revenue"]
    type: sum
    sql: ${order_items.sale_price} ;;
    filters: [products.category: "Socks,Socks & Hosiery"]
    value_format_name: usd
  }

  measure: sock_revenue_share {
    label: "Socks & Hosiery Revenue Share"
    description: "Share of total store gross revenue generated specifically from customers buying socks and hosiery across men's and women's lines."
    synonyms: ["sock revenue share", "sock revenue pct", "socks and hosiery revenue share"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${total_sock_revenue} / NULLIF(${order_items.total_revenue}, 0) ;;
    value_format_name: percent_2
  }
}
