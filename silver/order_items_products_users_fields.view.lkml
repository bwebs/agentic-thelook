view: order_items_products_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${order_items.id} ;;
  }

  dimension: is_cross_department_purchase {
    hidden: yes
    type: yesno
    description: "Helper flag indicating whether a male shopper purchased an item from the Women's department or a female shopper purchased an item from the Men's department."
    sql: (${users.gender} = 'M' AND ${products.department} = 'Women')
      OR (${users.gender} = 'F' AND ${products.department} = 'Men') ;;
  }

  measure: cross_department_gift_items {
    label: "Cross-Department Gift Items"
    description: "Count of ordered line items where a male shopper purchased from the Women's department or a female shopper purchased from the Men's department."
    synonyms: ["cross department gift items", "cross-shopping items", "gender cross-shopping items"]
    type: count
    filters: [is_cross_department_purchase: "yes"]
  }

  measure: cross_shopping_rate {
    label: "Gender-Bending Wardrobe Cross-Shopping Index"
    description: "Gender-Bending Wardrobe Cross-Shopping Index measures how often male shoppers buy items from the women's department or female shoppers buy items from the men's department. The seasonal merchandising team tracks this cross-department purchasing rate to plan gift-giving campaigns around Valentine's Day, Mother's Day, and Father's Day."
    synonyms: ["cross shopping pct", "cross-department purchasing rate", "cross shopping index", "wardrobe cross-shopping index"]
    type: number
    tags: ["non_additive"]
    sql: 1.0 * ${cross_department_gift_items} / NULLIF(${order_items.count}, 0) ;;
    value_format_name: percent_2
  }
}
