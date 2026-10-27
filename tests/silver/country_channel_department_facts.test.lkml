include: "../../silver/explores/country_channel_department_facts.explore.lkml"

test: country_channel_department_facts_invariants {
  explore_source: country_channel_department_facts {
    column: country { field: country_channel_department_facts.country }
    column: channel_dept_rank_in_country { field: country_channel_department_facts.channel_dept_rank_in_country }
    column: orders_count { field: country_channel_department_facts.orders_count }
    column: items_count { field: country_channel_department_facts.items_count }
    column: gross_margin { field: country_channel_department_facts.gross_margin }
    filters: [
      country_channel_department_facts.country: "United States",
      country_channel_department_facts.channel_dept_rank_in_country: "<=3"
    ]
  }
  assert: country_rank_and_margin_bounds {
    expression: ${country_channel_department_facts.country} = "United States" AND ${country_channel_department_facts.channel_dept_rank_in_country} >= 1 AND ${country_channel_department_facts.channel_dept_rank_in_country} <= 3 AND ${country_channel_department_facts.items_count} >= ${country_channel_department_facts.orders_count} AND ${country_channel_department_facts.orders_count} > 0 AND ${country_channel_department_facts.gross_margin} > 0 ;;
  }
}
