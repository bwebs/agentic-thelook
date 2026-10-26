include: "../../silver/explores/users.explore.lkml"

test: users_2024_01_01_per_capita_spend_metrics {
  explore_source: users {
    column: registered_users { field: users.count }
    column: avg_customer_age { field: users.avg_customer_age }
    column: items_purchased { field: order_items.count }
    column: total_revenue { field: order_items.total_revenue }
    column: revenue_per_registered_user { field: order_items_users_fields.revenue_per_registered_user }
    column: avg_activity_weighted_user_age { field: order_items_users_fields.avg_activity_weighted_user_age }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
  }
  assert: registered_users_matches {
    expression: ${users.count} = 38 ;;
  }
  assert: avg_customer_age_matches {
    expression: round(${users.avg_customer_age}, 2) = 35.45 ;;
  }
  assert: items_purchased_matches {
    expression: ${order_items.count} = 52 ;;
  }
  assert: total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 2623.38 ;;
  }
  assert: revenue_per_registered_user_matches {
    expression: round(${order_items_users_fields.revenue_per_registered_user}, 2) = 69.04 ;;
  }
  assert: avg_activity_weighted_user_age_matches {
    expression: round(${order_items_users_fields.avg_activity_weighted_user_age}, 1) = 39.3 ;;
  }
}

test: users_2024_01_01_ghost_account_metrics {
  explore_source: users {
    column: registered_users { field: users.count }
    column: buying_users { field: orders.distinct_users }
    column: ghost_users { field: orders_users_fields.ghost_users }
    column: ghost_account_rate { field: orders_users_fields.ghost_account_rate }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
  }
  assert: registered_users_matches {
    expression: ${users.count} = 33 ;;
  }
  assert: ghost_users_non_negative {
    expression: ${orders_users_fields.ghost_users} >= 0 ;;
  }
  assert: ghost_users_complement_matches {
    expression: ${orders_users_fields.ghost_users} = ${users.count} - ${orders.distinct_users} ;;
  }
  assert: ghost_account_rate_non_negative {
    expression: ${orders_users_fields.ghost_account_rate} >= 0 ;;
  }
  assert: ghost_account_rate_at_most_one {
    expression: ${orders_users_fields.ghost_account_rate} <= 1 ;;
  }
  assert: ghost_account_rate_formula_matches {
    expression: round(${orders_users_fields.ghost_account_rate}, 4) = round(1.0 * ${orders_users_fields.ghost_users} / ${users.count}, 4) ;;
  }
}

test: users_2022_cohort_year_1_survival_metrics {
  explore_source: users {
    column: initial_cohort_users { field: user_cohort_facts.initial_cohort_users }
    column: active_buyers { field: order_items.distinct_users }
    column: cohort_revenue { field: order_items.total_revenue }
    column: buyer_activation_survival_rate { field: order_items_user_cohort_facts_fields.buyer_activation_survival_rate }
    column: revenue_per_cohort_user { field: order_items_user_cohort_facts_fields.revenue_per_cohort_user }
    filters: {
      field: users.cohort_signup_year
      value: "2022"
    }
    filters: {
      field: order_items_users_fields.years_since_signup
      value: "1"
    }
  }
  assert: initial_cohort_users_matches {
    expression: ${user_cohort_facts.initial_cohort_users} = 12441 ;;
  }
  assert: active_buyers_matches {
    expression: ${order_items.distinct_users} = 3182 ;;
  }
  assert: cohort_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 305644.78 ;;
  }
  assert: buyer_activation_survival_rate_matches {
    expression: round(${order_items_user_cohort_facts_fields.buyer_activation_survival_rate}, 4) = 0.2558 ;;
  }
  assert: revenue_per_cohort_user_matches {
    expression: round(${order_items_user_cohort_facts_fields.revenue_per_cohort_user}, 2) = 24.57 ;;
  }
}

test: users_id_le_1000_oceanic_spend_invariants {
  explore_source: users {
    column: oceanic_spend_tier { field: user_spend_facts.oceanic_spend_tier }
    column: buyers_count { field: users.count }
    column: tier_total_revenue { field: order_items.total_revenue }
    column: avg_customer_ltv { field: user_spend_facts.avg_customer_ltv }
    filters: {
      field: users.id
      value: "<=1000"
    }
    filters: {
      field: user_spend_facts.user_id
      value: "NOT NULL"
    }
    sorts: [user_spend_facts.oceanic_spend_tier: asc]
  }
  assert: plankton_and_minnow_ltv_bounds_hold {
    expression: index(${user_spend_facts.oceanic_spend_tier}, 1) = "Plankton (<$30 LTV)" AND index(${user_spend_facts.avg_customer_ltv}, 1) > 0 AND index(${user_spend_facts.avg_customer_ltv}, 1) < 30 AND index(${user_spend_facts.oceanic_spend_tier}, 2) = "Minnow ($30-$99 LTV)" AND index(${user_spend_facts.avg_customer_ltv}, 2) >= 30 AND index(${user_spend_facts.avg_customer_ltv}, 2) < 100 ;;
  }
  assert: dolphin_and_mega_whale_ltv_bounds_hold {
    expression: index(${user_spend_facts.oceanic_spend_tier}, 3) = "Dolphin ($100-$299 LTV)" AND index(${user_spend_facts.avg_customer_ltv}, 3) >= 100 AND index(${user_spend_facts.avg_customer_ltv}, 3) < 300 AND index(${user_spend_facts.oceanic_spend_tier}, 4) = "Moby Dick Mega-Whale ($300+ LTV)" AND index(${user_spend_facts.avg_customer_ltv}, 4) >= 300 ;;
  }
}

test: users_id_le_1000_loyalty_tier_invariants {
  explore_source: users {
    column: customer_loyalty_tier { field: user_order_facts.customer_loyalty_tier }
    column: customer_count { field: users.count }
    column: orders_contributed { field: orders.count }
    column: items_contributed { field: orders.total_items }
    filters: {
      field: users.id
      value: "<=1000"
    }
    sorts: [user_order_facts.customer_loyalty_tier: asc]
  }
  assert: user_slice_partitions_all_1000_customers {
    expression: sum(${users.count}) = 1000 ;;
  }
  assert: ghost_and_tourist_order_bounds_hold {
    expression: index(${user_order_facts.customer_loyalty_tier}, 1) = "Window-Shopping Ghost (0 Orders)" AND index(${orders.count}, 1) = 0 AND index(${orders.total_items}, 1) = 0 AND index(${user_order_facts.customer_loyalty_tier}, 2) = "One-and-Done Tourist (1 Order)" AND index(${orders.count}, 2) = index(${users.count}, 2) ;;
  }
  assert: double_dipper_and_regular_order_bounds_hold {
    expression: index(${user_order_facts.customer_loyalty_tier}, 3) = "Repeat Double-Dipper (2 Orders)" AND index(${orders.count}, 3) = 2 * index(${users.count}, 3) AND index(${user_order_facts.customer_loyalty_tier}, 4) = "Cult Die-Hard Regular (3+ Orders)" AND index(${orders.count}, 4) >= 3 * index(${users.count}, 4) ;;
  }
}

test: users_id_le_5000_spend_trajectory_invariants {
  explore_source: users {
    column: repeat_customers { field: users.count }
    column: avg_first_order_spend { field: user_spend_trajectory_facts.avg_first_order_spend }
    column: avg_latest_order_spend { field: user_spend_trajectory_facts.avg_latest_order_spend }
    filters: [
      users.id: "<=5000",
      user_spend_trajectory_facts.spend_trajectory_persona: "Big-Spender Escalator (Latest >= 1.25x First Order)"
    ]
  }
  assert: escalator_spend_trajectory_holds {
    expression: ${users.count} > 0
      AND ${user_spend_trajectory_facts.avg_latest_order_spend} >= 1.25 * ${user_spend_trajectory_facts.avg_first_order_spend} ;;
  }
}

test: users_id_le_5000_clickstream_intent_and_ratio_invariants {
  explore_source: users {
    column: clickstream_intent_persona { field: user_click_facts_user_spend_facts_users_fields.clickstream_intent_persona }
    column: users_count { field: users.count }
    column: avg_user_clicks { field: user_click_facts_user_spend_facts_users_fields.avg_user_clicks }
    column: avg_user_items_bought { field: user_click_facts_user_spend_facts_users_fields.avg_user_items_bought }
    column: total_clicks { field: events.count }
    column: items_bought { field: order_items.count }
    column: clicks_per_item_bought { field: events_order_items_fields.clicks_per_item_bought }
    filters: [users.id: "<=5000"]
  }
  assert: clickstream_intent_personas_and_ratios_hold {
    expression: NOT is_null(${user_click_facts_user_spend_facts_users_fields.clickstream_intent_persona})
      AND ${users.count} > 0
      AND ${user_click_facts_user_spend_facts_users_fields.avg_user_clicks} >= 0
      AND ${user_click_facts_user_spend_facts_users_fields.avg_user_items_bought} >= 0
      AND (
        ${order_items.count} = 0
        OR round(${events_order_items_fields.clicks_per_item_bought}, 4) = round(1.0 * ${events.count} / ${order_items.count}, 4)
      ) ;;
  }
}
