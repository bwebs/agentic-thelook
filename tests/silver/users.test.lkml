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

test: users_2024_01_complete_post_signup_order_lag {
  explore_source: users {
    column: avg_days_from_signup_to_order { field: orders_users_fields.avg_days_from_signup_to_order }
    filters: {
      field: orders.created_date
      value: "2024-01"
    }
    filters: {
      field: orders.status
      value: "Complete"
    }
    filters: {
      field: orders_users_fields.is_post_signup_order
      value: "yes"
    }
  }
  assert: avg_days_from_signup_to_order_matches {
    expression: round(${orders_users_fields.avg_days_from_signup_to_order}, 1) = 771.3 ;;
  }
}

test: users_id_le_1000_buyer_personas_invariants {
  explore_source: users {
    column: activation_velocity_persona { field: user_order_facts_users_fields.activation_velocity_persona }
    column: return_behavior_persona { field: user_spend_facts.return_behavior_persona }
    column: customer_margin_archetype { field: user_spend_facts.customer_margin_archetype }
    column: national_wealth_tier { field: user_spend_facts.national_wealth_tier }
    column: buyer_count { field: users.count }
    column: total_lifetime_spend { field: user_spend_facts.total_lifetime_spend }
    column: total_lifetime_profit { field: user_spend_facts.total_lifetime_profit }
    column: blended_lifetime_margin_ratio { field: user_spend_facts.blended_lifetime_margin_ratio }
    filters: {
      field: users.id
      value: "<=1000"
    }
    filters: {
      field: user_spend_facts.user_id
      value: "NOT NULL"
    }
    filters: {
      field: user_order_facts.user_id
      value: "NOT NULL"
    }
  }
  assert: personas_populated_for_buyers {
    expression: NOT is_null(${user_order_facts_users_fields.activation_velocity_persona}) AND NOT is_null(${user_spend_facts.return_behavior_persona}) AND NOT is_null(${user_spend_facts.customer_margin_archetype}) AND NOT is_null(${user_spend_facts.national_wealth_tier}) ;;
  }
  assert: buyer_count_positive {
    expression: ${users.count} > 0 ;;
  }
  assert: blended_margin_consistent {
    expression: ${user_spend_facts.total_lifetime_spend} > 0 AND ${user_spend_facts.total_lifetime_spend} >= ${user_spend_facts.total_lifetime_profit} AND round(${user_spend_facts.blended_lifetime_margin_ratio}, 6) = round(${user_spend_facts.total_lifetime_profit} / ${user_spend_facts.total_lifetime_spend}, 6) ;;
  }
}

test: users_channel_attribution_persona_invariants {
  explore_source: users {
    column: channel_attribution_persona { field: user_click_facts.channel_attribution_persona }
    column: count { field: users.count }
    column: avg_channels_touched { field: user_click_facts.avg_channels_touched }
    filters: [
      users.id: "<=1000",
      user_click_facts.total_clicks: ">0"
    ]
    sorts: [user_click_facts.channel_attribution_persona: asc]
  }
  assert: non_null_persona_and_positive_users {
    expression: NOT is_null(${user_click_facts.channel_attribution_persona})
      AND ${users.count} > 0 ;;
  }
  assert: channel_bounds_by_persona {
    expression: if(
      ${user_click_facts.channel_attribution_persona} = "Single-Channel Purist (1 Channel Only)",
      round(${user_click_facts.avg_channels_touched}, 4) = 1,
      if(
        ${user_click_facts.channel_attribution_persona} = "Omnichannel Everywhere Enthusiast (3+ Channels)",
        ${user_click_facts.avg_channels_touched} >= 3,
        ${user_click_facts.avg_channels_touched} >= 1
      )
    ) ;;
  }
}

test: users_department_allegiance_invariants {
  explore_source: users {
    column: department_allegiance { field: user_spend_facts.department_allegiance }
    column: count { field: users.count }
    column: total_items_bought { field: user_spend_facts.total_items_bought }
    column: total_lifetime_spend { field: user_spend_facts.total_lifetime_spend }
    column: total_event_weighted_revenue { field: events_order_items_fields.total_event_weighted_revenue }
    filters: [
      users.id: "<=1000",
      user_spend_facts.user_id: "NOT NULL"
    ]
    sorts: [user_spend_facts.department_allegiance: asc]
  }
  assert: non_null_allegiance_and_buyer_floor {
    expression: NOT is_null(${user_spend_facts.department_allegiance})
      AND ${users.count} > 0
      AND ${user_spend_facts.total_items_bought} >= ${users.count}
      AND ${user_spend_facts.total_lifetime_spend} > 0 ;;
  }
  assert: event_weighted_revenue_at_least_lifetime_spend {
    expression: round(${events_order_items_fields.total_event_weighted_revenue}, 2) >= round(${user_spend_facts.total_lifetime_spend}, 2) ;;
  }
}

test: users_2024_01_01_warehouse_proximity_metrics {
  explore_source: users {
    column: warehouse_proximity_tier { field: user_warehouse_proximity_facts.warehouse_proximity_tier }
    column: count { field: users.count }
    column: avg_nearest_dc_km { field: user_warehouse_proximity_facts.avg_nearest_dc_km }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
    sorts: [user_warehouse_proximity_facts.warehouse_proximity_tier: asc]
  }
  assert: forklift_neighbor_tier_label_matches {
    expression: index(${user_warehouse_proximity_facts.warehouse_proximity_tier}, 1) = "Forklift Earshot Neighbor (<100 km to Warehouse)" ;;
  }
  assert: forklift_neighbor_count_matches {
    expression: index(${users.count}, 1) = 1 ;;
  }
  assert: forklift_neighbor_avg_km_matches {
    expression: round(index(${user_warehouse_proximity_facts.avg_nearest_dc_km}, 1), 1) = 92.9 ;;
  }
  assert: transoceanic_expedition_count_matches {
    expression: index(${users.count}, 4) = 29 ;;
  }
  assert: transoceanic_expedition_avg_km_matches {
    expression: round(index(${user_warehouse_proximity_facts.avg_nearest_dc_km}, 4), 1) = 8380.8 ;;
  }
}

test: users_first_1000_lifecycle_and_persona_invariants {
  explore_source: users {
    column: lifecycle_resurrection_state { field: user_click_facts_user_order_facts_users_fields.lifecycle_resurrection_state }
    column: four_d_customer_persona { field: user_spend_facts_users_fields.four_d_customer_persona }
    column: users_count { field: users.count }
    column: active_buyers { field: user_spend_facts.count }
    column: avg_user_lifetime_orders { field: user_order_facts_users_fields.avg_user_lifetime_orders }
    column: avg_user_gross_spend { field: user_spend_facts_users_fields.avg_user_gross_spend }
    column: avg_user_retained_profit { field: user_spend_facts_users_fields.avg_user_retained_profit }
    column: total_user_retained_profit { field: user_spend_facts_users_fields.total_user_retained_profit }
    filters: [users.id: "<=1000"]
  }
  assert: lifecycle_and_persona_exhaustive {
    expression: NOT is_null(${user_click_facts_user_order_facts_users_fields.lifecycle_resurrection_state})
      AND NOT is_null(${user_spend_facts_users_fields.four_d_customer_persona})
      AND ${users.count} > 0
      AND ${user_spend_facts.count} <= ${users.count} ;;
  }
  assert: spend_and_retained_profit_algebraic_bounds {
    expression: ${user_order_facts_users_fields.avg_user_lifetime_orders} >= 0
      AND ${user_spend_facts_users_fields.avg_user_gross_spend} >= ${user_spend_facts_users_fields.avg_user_retained_profit}
      AND abs(${user_spend_facts_users_fields.total_user_retained_profit} - (${users.count} * ${user_spend_facts_users_fields.avg_user_retained_profit})) < 0.01 ;;
  }
}

test: users_first_1000_cognitive_friction_invariants {
  explore_source: users {
    column: cognitive_friction_tier { field: user_click_facts_user_spend_facts_users_fields.cognitive_friction_tier }
    column: users_count { field: users.count }
    column: avg_user_sessions { field: user_click_facts.avg_user_sessions }
    column: avg_user_url_depth { field: user_click_facts.avg_user_url_depth }
    filters: [
      users.id: "<=1000",
      user_click_facts.user_id: "NOT NULL"
    ]
  }
  assert: cognitive_friction_exhaustive_and_bounded {
    expression: NOT is_null(${user_click_facts_user_spend_facts_users_fields.cognitive_friction_tier})
      AND ${users.count} > 0
      AND ${user_click_facts.avg_user_sessions} >= 1
      AND ${user_click_facts.avg_user_url_depth} >= 1 ;;
  }
}
