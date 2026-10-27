include: "../../silver/explores/category_warehouse_chaos_facts.explore.lkml"

test: category_warehouse_chaos_facts_invariants {
  explore_source: category_warehouse_chaos_facts {
    column: department { field: category_warehouse_chaos_facts.department }
    column: profit_rank_in_dept { field: category_warehouse_chaos_facts.profit_rank_in_dept }
    column: profit_percentile_rank { field: category_warehouse_chaos_facts.profit_percentile_rank }
    column: total_units { field: category_warehouse_chaos_facts.total_units }
    column: loss_rate { field: category_warehouse_chaos_facts.loss_rate }
    column: grand_unified_chaos_singularity_score { field: category_warehouse_chaos_facts.grand_unified_chaos_singularity_score }
    filters: [
      category_warehouse_chaos_facts.profit_rank_in_dept: "1"
    ]
  }
  assert: corridor_volume_and_rank_bounds {
    expression: ${category_warehouse_chaos_facts.profit_rank_in_dept} = 1 AND ${category_warehouse_chaos_facts.total_units} >= 15 AND ${category_warehouse_chaos_facts.profit_percentile_rank} >= 0 AND ${category_warehouse_chaos_facts.profit_percentile_rank} <= 1 ;;
  }
  assert: chaos_index_and_loss_bounds {
    expression: ${category_warehouse_chaos_facts.loss_rate} >= 0 AND ${category_warehouse_chaos_facts.loss_rate} <= 1 AND ${category_warehouse_chaos_facts.grand_unified_chaos_singularity_score} > 0 ;;
  }
}
