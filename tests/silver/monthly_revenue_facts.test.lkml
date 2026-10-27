include: "../../silver/explores/monthly_revenue_facts.explore.lkml"

test: monthly_revenue_facts_2024_01_momentum {
  explore_source: monthly_revenue_facts {
    column: orders_count { field: monthly_revenue_facts.orders_count }
    column: items_count { field: monthly_revenue_facts.items_count }
    column: monthly_revenue { field: monthly_revenue_facts.monthly_revenue }
    column: prev_month_revenue { field: monthly_revenue_facts.prev_month_revenue }
    column: mom_revenue_growth_rate { field: monthly_revenue_facts.mom_revenue_growth_rate }
    column: rolling_3m_avg_revenue { field: monthly_revenue_facts.rolling_3m_avg_revenue }
    column: cumulative_all_time_revenue { field: monthly_revenue_facts.cumulative_all_time_revenue }
    filters: [monthly_revenue_facts.created_month: "2024-01"]
  }
  assert: monthly_volume_and_revenue_match {
    expression: ${monthly_revenue_facts.orders_count} = 1436 AND ${monthly_revenue_facts.items_count} = 1975 AND round(${monthly_revenue_facts.monthly_revenue}, 2) = 119747.25 ;;
  }
  assert: prior_month_and_whiplash_match {
    expression: round(${monthly_revenue_facts.prev_month_revenue}, 2) = 121554.86 AND round(${monthly_revenue_facts.mom_revenue_growth_rate}, 4) = -0.0149 ;;
  }
  assert: rolling_and_cumulative_revenue_match {
    expression: round(${monthly_revenue_facts.rolling_3m_avg_revenue}, 2) = 117578.07 AND round(${monthly_revenue_facts.cumulative_all_time_revenue}, 2) = 2970882.55 ;;
  }
}
