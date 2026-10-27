include: "/silver/country_channel_department_facts.view.lkml"

explore: country_channel_department_facts {
  label: "Country Channel-Department Margin Leaders"
  view_name: country_channel_department_facts
  hidden: no

  query: top_2_channel_departments_per_country {
    description: "Top 20 highest-margin (country, acquisition channel, product department) segments among the top 2 gross-margin leaders inside each country."
    dimensions: [
      country_channel_department_facts.country,
      country_channel_department_facts.traffic_source,
      country_channel_department_facts.department,
      country_channel_department_facts.orders_count,
      country_channel_department_facts.gross_rev,
      country_channel_department_facts.gross_margin,
      country_channel_department_facts.avg_km,
      country_channel_department_facts.channel_dept_rank_in_country
    ]
    filters: [country_channel_department_facts.channel_dept_rank_in_country: "<=2"]
    sorts: [country_channel_department_facts.gross_margin: desc]
    limit: 20
  }
}
