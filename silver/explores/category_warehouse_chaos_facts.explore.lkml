include: "/silver/category_warehouse_chaos_facts.view.lkml"

explore: category_warehouse_chaos_facts {
  label: "Category-Warehouse Chaos Index"
  view_name: category_warehouse_chaos_facts
  hidden: no

  query: top_chaos_singularity_category_warehouse_corridors {
    description: "Top 25 category and fulfillment warehouse corridors ranked by the Omniscient Grand Unified Chaos Index alongside buyer age, gross revenue, chaos-adjusted net profit, reversal loss rate, shelf dwell days, fulfillment hours, shipment distance, department rank, and global profit percentile."
    dimensions: [
      category_warehouse_chaos_facts.department,
      category_warehouse_chaos_facts.category,
      category_warehouse_chaos_facts.warehouse_name,
      category_warehouse_chaos_facts.total_units,
      category_warehouse_chaos_facts.avg_buyer_age,
      category_warehouse_chaos_facts.gross_revenue,
      category_warehouse_chaos_facts.chaos_adjusted_net_profit,
      category_warehouse_chaos_facts.loss_rate,
      category_warehouse_chaos_facts.avg_shelf_dwell_days,
      category_warehouse_chaos_facts.avg_fulfillment_hours,
      category_warehouse_chaos_facts.avg_shipment_km,
      category_warehouse_chaos_facts.grand_unified_chaos_singularity_score,
      category_warehouse_chaos_facts.profit_rank_in_dept,
      category_warehouse_chaos_facts.profit_percentile_rank
    ]
    sorts: [category_warehouse_chaos_facts.grand_unified_chaos_singularity_score: desc]
    limit: 25
  }
}
