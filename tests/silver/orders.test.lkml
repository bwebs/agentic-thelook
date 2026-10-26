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
