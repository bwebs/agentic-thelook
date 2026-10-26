view: user_click_facts_user_spend_facts_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${users.id} ;;
  }

  dimension: clickstream_intent_persona {
    label: "Clickstream Tease versus Sniping Assassin"
    description: "Clickstream Tease versus Sniping Assassin classifies customers by comparing their total lifetime website clicks against their actual purchases: Sniping Assassins who buy in five clicks or fewer, Deliberate Researchers who buy after six or more clicks, Chronic Window Teases who click ten or more times without ever spending a dime, and Ghost Passersby. Paid retargeting teams use this persona to avoid burning ad budget chasing chronic window shoppers who never convert."
    synonyms: ["clickstream intent persona", "clickstream tease vs sniping assassin", "sniping assassin persona", "window tease persona"]
    case: {
      when: {
        sql: COALESCE(${user_spend_facts.items_bought}, 0) > 0 AND ${user_click_facts.total_clicks} <= 5 ;;
        label: "Sniping Assassin Buyer (<=5 Clicks & Bought)"
      }
      when: {
        sql: COALESCE(${user_spend_facts.items_bought}, 0) > 0 ;;
        label: "Deliberate Researcher Buyer (6+ Clicks & Bought)"
      }
      when: {
        sql: COALESCE(${user_spend_facts.items_bought}, 0) = 0 AND ${user_click_facts.total_clicks} >= 10 ;;
        label: "Chronic Window Tease (10+ Clicks & $0 Spent)"
      }
      else: "Ghost Passerby (<10 Clicks & $0 Spent)"
    }
  }

  measure: avg_user_clicks {
    label: "Average Lifetime Clicks per User"
    description: "Mean cumulative website clicks across registered customers (counting zero-click accounts as 0)."
    synonyms: ["avg clicks", "average clicks per customer"]
    tags: ["non_additive"]
    type: average
    sql: ${user_click_facts.total_clicks} ;;
    value_format_name: decimal_1
  }

  measure: avg_user_items_bought {
    label: "Average Lifetime Items Bought per User"
    description: "Mean cumulative order items purchased across registered customers (counting non-purchasing accounts as 0)."
    synonyms: ["avg items bought", "average items bought per customer"]
    tags: ["non_additive"]
    type: average
    sql: COALESCE(${user_spend_facts.items_bought}, 0) ;;
    value_format_name: decimal_2
  }
}
