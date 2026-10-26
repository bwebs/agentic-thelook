view: user_click_facts_user_order_facts_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${users.id} ;;
  }

  dimension: lifecycle_resurrection_state {
    label: "Customer Churn Hibernation and Resurrection State"
    description: "Customer Churn Hibernation and Resurrection State classifies every user's live lifecycle status across orders and site visits into Freshly Activated Seedlings, Active Healthy Regulars, Resurrected Lazarus Shoppers who placed a new order after more than six months of silence, Slipping At-Risk Drifters, Deep-Freeze Churned Corpses silent for over a year, Browsing-Only Apparitions, and Silent Registry Phantoms. Win-back marketing teams use this lifecycle state to target reactivated Lazarus shoppers and send comeback offers to long-dormant accounts."
    synonyms: [
      "lifecycle resurrection state",
      "customer churn hibernation and resurrection state",
      "lazarus shopper state",
      "churn hibernation tier"
    ]
    case: {
      when: {
        sql: ${user_order_facts.user_id} IS NOT NULL AND ${user_order_facts.max_inter_order_gap_days} < 180 AND ${user_order_facts.days_since_first_order_ref} <= 90 ;;
        label: "Freshly Activated Seedling (First Order <=90d Ago)"
      }
      when: {
        sql: ${user_order_facts.user_id} IS NOT NULL AND ${user_order_facts.max_inter_order_gap_days} < 180 AND ${user_order_facts.days_since_last_order_ref} <= 180 ;;
        label: "Active Healthy Regular (Bought Within 180d)"
      }
      when: {
        sql: ${user_order_facts.user_id} IS NOT NULL AND ${user_order_facts.max_inter_order_gap_days} >= 180 ;;
        label: "Resurrected Lazarus Shopper (Survived 180+ Day Order Gap)"
      }
      when: {
        sql: ${user_order_facts.user_id} IS NOT NULL AND ${user_order_facts.days_since_last_order_ref} <= 365 ;;
        label: "Slipping At-Risk Drifter (181-365d Since Last Order)"
      }
      when: {
        sql: ${user_order_facts.user_id} IS NOT NULL ;;
        label: "Deep-Freeze Churned Corpse (365+ Days Since Last Order)"
      }
      when: {
        sql: ${user_order_facts.user_id} IS NULL AND ${user_click_facts.user_id} IS NOT NULL ;;
        label: "Browsing-Only Apparition (Clicks, 0 Orders)"
      }
      else: "Silent Registry Phantom (0 Clicks, 0 Orders)"
    }
  }
}
