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

  dimension: cognitive_friction_tier {
    label: "Clickstream Session Cognitive Load and Friction Tier"
    description: "Clickstream Session Cognitive Load and Friction Tier combines a customer's browsing depth, page dwell time, checkout cancel clicks, and completed orders to classify clicking users into Frictionless Flow-State Closers, High-Cognitive-Load Comparison Grinders, Frustrated Checkout Abandoners who hit cart or cancel with zero completed spend, and Disoriented Casual Wanderers (returns NULL for accounts with zero clickstream events). Product engineering teams use this friction taxonomy alongside browser cancel rates to prioritize checkout simplifications."
    synonyms: [
      "cognitive friction tier",
      "clickstream session cognitive load and friction tier",
      "session friction tier",
      "checkout friction persona"
    ]
    case: {
      when: {
        sql: ${user_click_facts.user_id} IS NOT NULL AND COALESCE(${user_spend_facts.items_bought}, 0) > 0 AND ${user_click_facts.cancel_events} = 0 AND ${user_click_facts.total_clicks} <= 15 ;;
        label: "Frictionless Flow-State Closer (Bought Smoothly, 0 Cancels)"
      }
      when: {
        sql: ${user_click_facts.user_id} IS NOT NULL AND COALESCE(${user_spend_facts.items_bought}, 0) > 0 ;;
        label: "High-Cognitive-Load Comparison Grinder (Bought After Heavy Research/Cancels)"
      }
      when: {
        sql: ${user_click_facts.user_id} IS NOT NULL AND COALESCE(${user_spend_facts.items_bought}, 0) = 0 AND (${user_click_facts.cart_events} > 0 OR ${user_click_facts.cancel_events} > 0) ;;
        label: "Frustrated Checkout Abandoner (Reached Cart/Cancel, $0 Ledger Spend)"
      }
      when: {
        sql: ${user_click_facts.user_id} IS NOT NULL ;;
        label: "Disoriented Casual Wanderer (Top-of-Funnel Browsing Only)"
      }
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

  dimension: is_clicking_buyer {
    hidden: yes
    type: yesno
    sql: ${user_click_facts.user_id} IS NOT NULL AND ${user_spend_facts.user_id} IS NOT NULL ;;
  }

  dimension: user_clicks_per_dollar {
    label: "Customer Clicks per Dollar Spent"
    description: "Number of lifetime website clicks generated per dollar of lifetime spend for an active clicking buyer."
    synonyms: ["customer clicks per dollar", "buyer clicks per dollar spent"]
    type: number
    value_format_name: decimal_4
    sql: CASE WHEN ${is_clicking_buyer} THEN ${user_click_facts.total_clicks} / NULLIF(${user_spend_facts.lifetime_spend}, 0) END ;;
  }

  measure: _clicking_buyer_clicks {
    hidden: yes
    type: sum
    sql: ${user_click_facts.total_clicks} ;;
    filters: [is_clicking_buyer: "yes"]
  }

  measure: _clicking_buyer_spend {
    hidden: yes
    type: sum
    sql: ${user_spend_facts.lifetime_spend} ;;
    filters: [is_clicking_buyer: "yes"]
  }

  measure: avg_clicks_per_dollar_spent {
    label: "Average Clicks per Dollar Spent"
    description: "Mean per-buyer ratio of lifetime website clicks to lifetime dollar spend across active clicking buyers."
    synonyms: ["avg clicks per dollar spent", "average buyer clicks per dollar"]
    tags: ["non_additive"]
    type: average
    sql: ${user_clicks_per_dollar} ;;
    value_format_name: decimal_4
  }

  measure: clicks_per_dollar {
    label: "Clicks-per-Dollar Ratio"
    description: "Window-Shopper-to-Whale Clicks-per-Dollar Ratio measuring how many website clicks active buyers generate for every dollar they spend (sum of buyer clicks divided by sum of buyer spend)."
    synonyms: ["clicks per dollar", "global clicks per dollar", "window-shopper-to-whale clicks-per-dollar ratio"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${_clicking_buyer_clicks} / NULLIF(${_clicking_buyer_spend}, 0) ;;
    value_format_name: decimal_4
  }

  measure: revenue_per_click {
    label: "Revenue per Click (Active Buyers)"
    description: "Gross dollar spend generated per website click across active clicking buyers (sum of buyer spend divided by sum of buyer clicks)."
    synonyms: ["revenue per click", "global dollars per click", "dollars per click"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${_clicking_buyer_spend} / NULLIF(${_clicking_buyer_clicks}, 0) ;;
    value_format_name: usd
  }

  dimension: is_exact_telemetry_match {
    hidden: yes
    type: yesno
    sql: ${user_click_facts.purchase_events} = ${user_spend_facts.items_bought} ;;
  }

  dimension: is_telemetry_drift {
    hidden: yes
    type: yesno
    sql: ${user_click_facts.purchase_events} != ${user_spend_facts.items_bought} ;;
  }

  measure: ledger_vs_clickstream_unit_gap {
    label: "Ledger vs. Clickstream Purchase Unit Gap"
    description: "Difference between ground-truth financial order items purchased and recorded clickstream purchase events across customers (total_items_bought - total_purchase_events)."
    synonyms: ["ledger vs clickstream unit gap", "order vs click purchase gap"]
    tags: ["non_additive"]
    type: number
    value_format_name: decimal_0
    sql: ${user_spend_facts.total_items_bought} - ${user_click_facts.total_purchase_events} ;;
  }

  measure: exact_telemetry_match_users {
    label: "Exact Telemetry Match Buyers"
    description: "Count of clicking buyers whose recorded clickstream purchase event count exactly matches their financial ledger items bought."
    synonyms: ["exact telemetry match users", "telemetry matched buyers"]
    type: count
    filters: [is_exact_telemetry_match: "yes"]
  }

  measure: telemetry_drift_users {
    label: "Telemetry Drift Buyers"
    description: "Count of clicking buyers whose recorded clickstream purchase event count diverges from their financial ledger items bought."
    synonyms: ["telemetry drift users", "mismatched telemetry buyers"]
    type: count
    filters: [is_telemetry_drift: "yes"]
  }

  measure: net_margin_per_click {
    label: "Net Gross Profit Margin per Buyer Click"
    description: "Cumulative buyer gross profit (sale_price - cost) divided by total website clicks generated by buyers."
    synonyms: ["net margin per click", "profit per buyer click"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${user_spend_facts.total_lifetime_profit} / NULLIF(${_clicking_buyer_clicks}, 0) ;;
    value_format_name: usd
  }
}
