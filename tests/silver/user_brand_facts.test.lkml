include: "../../silver/explores/user_brand_facts.explore.lkml"

test: user_brand_facts_repeat_devotion_invariants {
  explore_source: user_brand_facts {
    column: distinct_buyers { field: user_brand_facts.count }
    column: repeat_brand_devotees { field: user_brand_facts.repeat_brand_devotees }
    column: cult_devotion_repeat_rate { field: user_brand_facts.cult_devotion_repeat_rate }
    column: max_units_by_single_buyer { field: user_brand_facts.max_units_by_single_buyer }
    filters: {
      field: user_brand_facts.user_id
      value: "<=5000"
    }
  }
  assert: devotee_counts_bounded {
    expression: ${user_brand_facts.count} > 0 AND ${user_brand_facts.repeat_brand_devotees} >= 0 AND ${user_brand_facts.repeat_brand_devotees} <= ${user_brand_facts.count} AND ${user_brand_facts.max_units_by_single_buyer} >= 1 ;;
  }
  assert: repeat_rate_matches_ratio {
    expression: round(1.0 * ${user_brand_facts.repeat_brand_devotees} / ${user_brand_facts.count}, 6) = round(${user_brand_facts.cult_devotion_repeat_rate}, 6) ;;
  }
}
