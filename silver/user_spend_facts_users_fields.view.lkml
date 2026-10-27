view: user_spend_facts_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${users.id} ;;
  }

  dimension: four_d_customer_persona {
    label: "4D Customer Persona Matrix"
    description: "The 4D Customer Persona Matrix combines lifetime spend, net profit margin, return habits, and browsing activity to assign every user into one of five holistic personas: Unicorn Dream VIPs with high spend, strong margins, and zero returns; High-Maintenance Diva Whales; Low-Touch Impulse Snacks; Margin-Draining Return Goblins; and Window-Shopping Specters. This master customer badge is synced to support and marketing profiles so teams immediately know a shopper's true net value to the business."
    synonyms: [
      "four d customer persona",
      "4d customer persona matrix",
      "4d customer persona",
      "customer value persona"
    ]
    case: {
      when: {
        sql: COALESCE(${user_spend_facts.items_bought}, 0) > 0 AND ${user_spend_facts.lifetime_spend} >= 100.0 AND ${user_spend_facts.status_returned_items} = 0 AND COALESCE(${user_spend_facts.lifetime_margin_ratio}, 0) >= 0.50 ;;
        label: "Unicorn Dream VIP ($100+ Spend, 50%+ Margin, 0 Returns)"
      }
      when: {
        sql: COALESCE(${user_spend_facts.items_bought}, 0) > 0 AND NOT (${user_spend_facts.status_returned_items} > 0 AND ${user_spend_facts.retained_net_profit} <= 10.0) AND ${user_spend_facts.lifetime_spend} >= 100.0 ;;
        label: "High-Maintenance Diva Whale ($100+ Spend, With Returns or Low Margin)"
      }
      when: {
        sql: COALESCE(${user_spend_facts.items_bought}, 0) > 0 AND NOT (${user_spend_facts.status_returned_items} > 0 AND ${user_spend_facts.retained_net_profit} <= 10.0) ;;
        label: "Low-Touch Impulse Snack (<$100 Spend, Positive Retained Profit)"
      }
      when: {
        sql: COALESCE(${user_spend_facts.items_bought}, 0) > 0 AND ${user_spend_facts.status_returned_items} > 0 AND ${user_spend_facts.retained_net_profit} <= 10.0 ;;
        label: "Margin-Draining Return Goblin (High Return Drag)"
      }
      else: "Window-Shopping Specter ($0 Spend)"
    }
  }

  measure: avg_user_gross_spend {
    label: "Average Gross Spend per User"
    description: "Mean cumulative gross dollar spend across registered customers (counting non-purchasing accounts as $0)."
    synonyms: ["avg gross spend", "avg ledger spend", "average spend per user"]
    tags: ["non_additive"]
    type: average
    value_format_name: usd
    sql: COALESCE(${user_spend_facts.lifetime_spend}, 0) ;;
  }

  measure: avg_user_retained_profit {
    label: "Average Retained Net Profit per User"
    description: "Mean cumulative retained net dollar profit across registered customers (counting non-purchasing accounts as $0)."
    synonyms: ["avg retained net profit", "average retained profit per user"]
    tags: ["non_additive"]
    type: average
    value_format_name: usd
    sql: COALESCE(${user_spend_facts.retained_net_profit}, 0) ;;
  }

  measure: total_user_retained_profit {
    label: "Total Retained Net Profit (All Users)"
    description: "Total retained net dollar profit summed across registered customers (defaulting $0 for cohorts with zero purchases)."
    synonyms: ["total retained profit", "retained channel profit"]
    type: sum
    value_format_name: usd
    sql: COALESCE(${user_spend_facts.retained_net_profit}, 0) ;;
  }

  measure: total_user_gross_spend {
    label: "Total Gross Spend (All Users)"
    description: "Total cumulative gross dollar spend summed across registered customers (defaulting $0 for cohorts with zero purchases)."
    synonyms: ["group total spend", "total cohort gross spend"]
    type: sum
    value_format_name: usd
    sql: COALESCE(${user_spend_facts.lifetime_spend}, 0) ;;
  }
}
