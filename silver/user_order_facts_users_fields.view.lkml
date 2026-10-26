view: user_order_facts_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${users.id} ;;
  }

  dimension_group: to_first_order {
    label: "To First Order"
    description: "Elapsed time between when the shopper created their user account and when they placed their very first order."
    type: duration
    intervals: [day]
    sql_start: ${users.created_raw} ;;
    sql_end: ${user_order_facts.first_order_raw} ;;
  }

  dimension: activation_velocity_persona {
    label: "Same-Day Signup-to-Swipe Impulse Buyer versus Slow Burner"
    description: "Same-Day Signup-to-Swipe Impulse Buyer versus Slow Burner classifies paying customers by how many days passed between creating their user account and placing their very first order, separating Instant Impulse Buyers who order within 24 hours from First-Month Warmups, Slow-Burn Ponderers, and Hibernating Sleeper Agents who wait over a year (returns NULL for non-purchasing accounts). Onboarding product managers also track the companion seven-day conversion window across acquisition channels to measure early activation speed."
    synonyms: ["activation velocity persona", "same-day signup-to-swipe impulse buyer vs slow burner", "signup to first order persona", "impulse buyer vs slow burner"]
    case: {
      when: {
        sql: ${days_to_first_order} <= 1 ;;
        label: "Instant Impulse Buyer (<=1 Day from Signup)"
      }
      when: {
        sql: ${days_to_first_order} <= 30 ;;
        label: "First-Month Warmup (2-30 Days)"
      }
      when: {
        sql: ${days_to_first_order} <= 365 ;;
        label: "Slow-Burn Ponderer (31-365 Days)"
      }
      when: {
        sql: ${user_order_facts.user_id} IS NOT NULL ;;
        label: "Hibernating Sleeper Agent (365+ Days to First Order)"
      }
    }
  }

  measure: avg_days_to_first_order {
    label: "Average Days to First Order"
    description: "Mean whole days elapsed between account creation and the customer's very first order."
    synonyms: ["avg days to first order", "average signup to first order lag"]
    tags: ["non_additive"]
    type: average
    sql: ${days_to_first_order} ;;
    value_format_name: decimal_1
  }
}
