include: "/silver/user_brand_facts.view.lkml"

explore: user_brand_facts {
  label: "Brand Repeat Buyer Devotion"
  view_name: user_brand_facts
  hidden: no

  query: top_brands_by_cult_devotion_repeat_rate {
    description: "Top 15 fashion brands (30+ distinct buyers) ranked by Cult Devotion Brand Repeat Rate alongside distinct buyers, repeat devotees, and maximum units purchased by one fan."
    dimensions: [user_brand_facts.brand]
    measures: [
      user_brand_facts.count,
      user_brand_facts.repeat_brand_devotees,
      user_brand_facts.cult_devotion_repeat_rate,
      user_brand_facts.max_units_by_single_buyer
    ]
    filters: [user_brand_facts.count: ">=30"]
    sorts: [user_brand_facts.cult_devotion_repeat_rate: desc]
    limit: 15
  }
}
