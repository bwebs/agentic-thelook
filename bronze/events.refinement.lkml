include: "events.view.lkml"

view: +events {
  measure: count {
    label: "Total Click Events"
    description: "Total volume of website interactions and clickstream events."
  }

  measure: unique_chaotic_sessions {
    label: "Unique Browsing Sessions"
    description: "Number of unique browsing sessions generating storefront traffic."
    type: count_distinct
    sql: ${session_id} ;;
  }

  measure: distinct_clicking_humans {
    label: "Distinct Clicking Shoppers"
    description: "Number of distinct shoppers generating website interactions."
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: cart_events {
    label: "Cart Events"
    description: "Number of clickstream events where shoppers add items to their cart (event_type = 'cart')."
    synonyms: ["carts", "add to cart events"]
    type: count
    filters: [event_type: "cart"]
  }

  measure: purchase_events {
    label: "Purchase Events"
    description: "Number of completed checkout clickstream events (event_type = 'purchase')."
    synonyms: ["purchases", "completed checkouts"]
    type: count
    filters: [event_type: "purchase"]
  }

  measure: cancel_events {
    label: "Rage-Quit Cancel Events"
    description: "Number of clickstream events where shoppers explicitly cancel out of a browsing flow (event_type = 'cancel')."
    synonyms: ["rage quit cancel events", "cancels", "cancel events"]
    type: count
    filters: [event_type: "cancel"]
  }

  measure: carts_per_purchase_ratio {
    label: "Carts per Purchase Ratio"
    description: "Ratio of add-to-cart events relative to completed checkout purchase events (cart_events / purchase_events)."
    synonyms: ["carts per purchase", "cart to purchase ratio"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${cart_events} / NULLIF(${purchase_events}, 0) ;;
    value_format_name: decimal_3
  }

  measure: cancel_to_cart_ratio {
    label: "Rage-Quit Cart Abandonment Ratio"
    description: "Rage-Quit Cart Abandonment Ratio compares how often shoppers explicitly cancel out of a browsing flow relative to add-to-cart events (cancel_events / cart_events). User experience designers monitor this ratio to see whether checkout friction or unexpected shipping fees are driving shoppers away at the last second."
    synonyms: ["cancel to cart pct", "cancel to cart ratio", "rage-quit cart abandonment ratio"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${cancel_events} / NULLIF(${cart_events}, 0) ;;
    value_format_name: percent_2
  }
}
