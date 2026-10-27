include: "/silver/monthly_revenue_facts.view.lkml"

explore: monthly_revenue_facts {
  label: "Monthly Revenue Whiplash & Rolling Momentum"
  view_name: monthly_revenue_facts
  hidden: no

  query: monthly_revenue_whiplash_and_rolling_momentum {
    description: "Trailing 24 months of monthly order count, gross revenue, prior-month revenue, MoM whiplash growth rate, 3-month rolling average momentum, and cumulative all-time revenue."
    dimensions: [
      monthly_revenue_facts.created_month,
      monthly_revenue_facts.orders_count,
      monthly_revenue_facts.monthly_revenue,
      monthly_revenue_facts.prev_month_revenue,
      monthly_revenue_facts.mom_revenue_growth_rate,
      monthly_revenue_facts.rolling_3m_avg_revenue,
      monthly_revenue_facts.cumulative_all_time_revenue
    ]
    sorts: [monthly_revenue_facts.created_month: desc]
    limit: 24
  }
}
