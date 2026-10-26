view: users_signup_activation {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${users.id} ;;
  }

  filter: signup_cohort_window {
    label: "Signup Cohort Window"
    description: "Runtime date window scoping customer account registrations included in the rolling 7-day activation cohort."
    type: date
    convert_tz: no
  }

  dimension: rolling_7d_window_outcome {
    label: "7-Day Rolling Signup Conversion Outcome"
    description: "Classifies cohort signups by whether they placed at least one order within 7 days of account creation ('Converted Within 7-Day Rolling Window' vs 'Unconverted After 7-Day Rolling Window')."
    synonyms: ["rolling 7d window outcome", "seven-day conversion window", "7d activation outcome"]
    case: {
      when: {
        sql: ${rolling_7d_orders.order_id} IS NOT NULL ;;
        label: "Converted Within 7-Day Rolling Window"
      }
      else: "Unconverted After 7-Day Rolling Window"
    }
  }
}
