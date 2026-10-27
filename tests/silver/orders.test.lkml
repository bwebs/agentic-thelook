include: "../../silver/explores/orders.explore.lkml"

test: orders_complete_basket_diversity_2024_01_01 {
  explore_source: orders {
    column: basket_diversity_archetype { field: order_basket_facts.basket_diversity_archetype }
    column: count { field: orders.count }
    column: avg_basket_units { field: order_basket_facts.avg_basket_units }
    column: avg_basket_distinct_brands { field: order_basket_facts.avg_basket_distinct_brands }
    column: avg_basket_spend { field: order_basket_facts.avg_basket_spend }
    column: total_basket_revenue { field: order_basket_facts.total_basket_revenue }
    filters: [
      orders.created_date: "2024-01-01",
      orders.status: "Complete",
      order_basket_facts.order_id: "NOT NULL"
    ]
    sorts: [order_basket_facts.basket_diversity_archetype: asc]
  }
  assert: outfit_builder_basket_metrics_match {
    expression: index(${order_basket_facts.basket_diversity_archetype}, 1) = "Head-to-Toe Complete Outfit Builder (3+ Distinct Categories)"
      AND index(${orders.count}, 1) = 1
      AND round(index(${order_basket_facts.avg_basket_units}, 1), 2) = 4
      AND round(index(${order_basket_facts.avg_basket_distinct_brands}, 1), 2) = 4
      AND round(index(${order_basket_facts.avg_basket_spend}, 1), 2) = 178.44
      AND round(index(${order_basket_facts.total_basket_revenue}, 1), 2) = 178.44 ;;
  }
  assert: dual_category_basket_metrics_match {
    expression: index(${order_basket_facts.basket_diversity_archetype}, 2) = "Dual-Category Mix-and-Matcher (2 Categories)"
      AND index(${orders.count}, 2) = 7
      AND round(index(${order_basket_facts.avg_basket_spend}, 2), 2) = 145.59
      AND round(index(${order_basket_facts.total_basket_revenue}, 2), 2) = 1019.12 ;;
  }
  assert: solo_sniper_basket_metrics_match {
    expression: index(${order_basket_facts.basket_diversity_archetype}, 3) = "Solo Item Sniper (1 Unit Total)"
      AND index(${orders.count}, 3) = 11
      AND round(index(${order_basket_facts.avg_basket_spend}, 3), 2) = 61.38
      AND round(index(${order_basket_facts.total_basket_revenue}, 3), 2) = 675.14 ;;
  }
}

test: orders_2024_06_01_inter_order_gap_metrics {
  explore_source: orders {
    column: max_inter_order_gap_days { field: orders_sequenced.max_inter_order_gap_days }
    column: count { field: orders.count }
    filters: [
      orders.created_date: "2024-06-01",
      orders.status: "Complete,Returned,Cancelled"
    ]
  }
  assert: max_inter_order_gap_and_count_match {
    expression: ${orders_sequenced.max_inter_order_gap_days} = 663
      AND ${orders.count} = 21 ;;
  }
}

test: orders_2024_01_repeat_spend_escalation {
  explore_source: orders {
    column: order_sequence_number { field: user_spend_trajectory_facts.order_sequence_number }
    column: distinct_users { field: orders.distinct_users }
    column: avg_order_spend { field: user_spend_trajectory_facts.avg_order_spend }
    column: avg_first_order_spend { field: user_spend_trajectory_facts.avg_first_order_spend }
    column: avg_spend_escalation_multiplier { field: user_spend_trajectory_facts.avg_spend_escalation_multiplier }
    filters: [
      orders.created_month: "2024-01",
      user_spend_trajectory_facts.user_order_count: ">=2"
    ]
    sorts: [user_spend_trajectory_facts.order_sequence_number: asc]
  }
  assert: step_one_baseline_identity {
    expression: index(${user_spend_trajectory_facts.order_sequence_number}, 1) = 1 AND round(index(${user_spend_trajectory_facts.avg_spend_escalation_multiplier}, 1), 3) = 1 AND round(index(${user_spend_trajectory_facts.avg_order_spend}, 1), 2) = round(index(${user_spend_trajectory_facts.avg_first_order_spend}, 1), 2) ;;
  }
  assert: step_two_escalation_populated {
    expression: index(${user_spend_trajectory_facts.order_sequence_number}, 2) = 2 AND index(${orders.distinct_users}, 2) > 0 AND index(${user_spend_trajectory_facts.avg_spend_escalation_multiplier}, 2) > 0 ;;
  }
}
