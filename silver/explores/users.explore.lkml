include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/users__name_tokens.view.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/explores/users_base.explore.lkml"
include: "/silver/order_items_users_fields.view.lkml"
include: "/silver/orders_users_fields.view.lkml"
include: "/silver/user_cohort_facts.view.lkml"
include: "/silver/order_items_user_cohort_facts_fields.view.lkml"

explore: users {
  extends: [users_base]
  label: "Users"
  view_name: users
  hidden: no

  join: orders {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${orders.user_id} ;;
  }

  join: orders_users_fields {
    view_label: "Users"
    sql: ;;
    relationship: one_to_one
  }

  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }

  join: order_items_users_fields {
    view_label: "Users"
    sql: ;;
    relationship: one_to_one
  }

  join: user_cohort_facts {
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.cohort_signup_year} = ${user_cohort_facts.cohort_signup_year} ;;
  }

  join: order_items_user_cohort_facts_fields {
    view_label: "Users"
    sql: ;;
    relationship: one_to_one
  }

  query: country_per_capita_fashion_spend {
    description: "Country Per-Capita Fashion Spend measures total revenue, average shopper age, and average spend per registered customer across every country we serve."
    dimensions: [users.country]
    measures: [
      users.count,
      users.avg_customer_age,
      order_items.count,
      order_items.total_revenue,
      order_items_users_fields.revenue_per_registered_user
    ]
    sorts: [order_items.total_revenue: desc]
  }

  query: channel_revenue_by_country_and_traffic_source {
    description: "Top 20 country and marketing traffic source combinations ranked by total channel revenue from purchasing customers."
    dimensions: [users.country, users.traffic_source]
    measures: [order_items.total_revenue]
    filters: [order_items.id: "NOT NULL"]
    sorts: [order_items.total_revenue: desc]
    limit: 20
  }

  query: ghost_account_overview {
    description: "Overall registered customers, buying users, dormant ghost accounts, and Ghost Account Window-Shopper Rate."
    measures: [
      users.count,
      orders.distinct_users,
      orders_users_fields.ghost_users,
      orders_users_fields.ghost_account_rate
    ]
  }

  query: ghost_account_rate_by_traffic_source {
    description: "Ghost Account Window-Shopper Rate and dormant signup pool broken down by customer acquisition traffic source."
    dimensions: [users.traffic_source]
    measures: [
      users.count,
      orders_users_fields.ghost_users,
      orders_users_fields.ghost_account_rate
    ]
    sorts: [orders_users_fields.ghost_account_rate: desc]
  }

  query: annual_cohort_vintage_decay_and_survival_matrix {
    description: "Annual Cohort Vintage Decay and Survival Matrix groups customers by the calendar year they first signed up and tracks how many remain active buyers and how much revenue they generate in each subsequent year of their tenure."
    dimensions: [
      users.cohort_signup_year,
      order_items_users_fields.years_since_signup
    ]
    measures: [
      user_cohort_facts.initial_cohort_users,
      order_items.distinct_users,
      order_items_user_cohort_facts_fields.buyer_activation_survival_rate,
      order_items.total_revenue,
      order_items_user_cohort_facts_fields.revenue_per_cohort_user
    ]
    filters: [order_items_users_fields.years_since_signup: ">=0"]
    sorts: [
      users.cohort_signup_year: asc,
      order_items_users_fields.years_since_signup: asc
    ]
  }

  query: young_customers {
    description: "Young Customer defines any registered shopper under the age of 25, covering our teen and early-twenties audience. Youth marketing teams use this segment to target student discount codes, campus promos, and streetwear campaigns."
    dimensions: [
      users.id,
      users.first_name,
      users.last_name,
      users.age,
      users.country
    ]
    filters: [users.is_young_customer: "yes"]
    limit: 25
  }

  query: new_customers {
    description: "New Customer identifies shoppers who created their store account during the current calendar year. Lifecycle marketing teams use this definition to enroll fresh signups into welcome email sequences and track recent acquisition momentum."
    dimensions: [
      users.id,
      users.first_name,
      users.last_name,
      users.age,
      users.country,
      users.created_time
    ]
    filters: [users.created_year: "this year"]
    sorts: [users.created_time: desc]
    limit: 25
  }

  query: thoroughfare_aristocracy_tiers {
    description: "Street Address Thoroughfare Aristocracy Tier groups customers by the kind of road named in their home street address, separating grand boulevards and avenues from quiet cul-de-sac courts, standard streets and roads, and international lanes. Direct-mail marketers use this playful neighborhood taxonomy to slice regional catalog mailings."
    dimensions: [users.thoroughfare_tier]
    measures: [
      users.count,
      users.avg_customer_age
    ]
    sorts: [users.count: desc]
  }

  query: hemisphere_and_equator_proximity_belts {
    description: "Hemisphere and Equator Proximity Belt segments our global customer base by north-south latitude and east-west longitude into the Northern High-Latitude Frost Belt, Northern Temperate Zone, Equatorial Tropics, and Southern Hemisphere Down-Under. Regional merchandising teams use this geographic belt to swap winter coat banners and summer swimwear promotions between northern and southern hemisphere shoppers."
    dimensions: [users.hemisphere_belt, users.longitude_sector]
    measures: [users.count]
    sorts: [
      users.hemisphere_belt: asc,
      users.count: desc
    ]
  }

  query: zip_code_numeric_parity_tribes {
    description: "Zip Code Numeric Parity Tribe divides customers into Even-Zip Aristocrats, Odd-Zip Rebels, and Alphanumeric International Postcode residents based on whether their postal code is an even number, an odd number, or contains letters, tracking user counts, average shopper age, and distinct countries represented."
    dimensions: [users.postal_code_parity]
    measures: [
      users.count,
      users.avg_customer_age,
      users.distinct_countries
    ]
    sorts: [users.count: desc]
  }

  query: generational_age_buckets {
    description: "Registered shopper count and average age across Generational Age Bucket life-stage cohorts."
    dimensions: [users.age_bucket]
    measures: [
      users.count,
      users.avg_customer_age
    ]
    sorts: [users.age_bucket: asc]
  }

  query: users_by_age_decade_and_gender {
    description: "Registered shopper count broken down by ten-year Age Decade and gender."
    dimensions: [
      users.age_decade,
      users.age_decade_label,
      users.gender
    ]
    measures: [users.count]
    sorts: [
      users.age_decade: asc,
      users.gender: asc
    ]
  }

  query: users_by_global_macro_region {
    description: "Registered shopper count across Global Macro Region commercial territories and individual countries."
    dimensions: [
      users.global_macro_region,
      users.country
    ]
    measures: [users.count]
    sorts: [
      users.global_macro_region: asc,
      users.count: desc
    ]
  }

  query: us_users_by_super_region_and_postal_zone {
    description: "Top 20 domestic US Super-Region and first-digit postal code zone combinations ranked by registered shopper count."
    dimensions: [
      users.us_super_region,
      users.postal_code_zone
    ]
    measures: [users.count]
    filters: [users.country: "United States"]
    sorts: [users.count: desc]
    limit: 20
  }

  query: name_phonetics_club_breakdown {
    description: "Registered shopper count and average age across Alliterative and Geminate Name VIP Club segments."
    dimensions: [users.name_phonetics_club]
    measures: [
      users.count,
      users.avg_customer_age
    ]
    sorts: [users.name_phonetics_club: asc]
  }

  query: alliterative_name_members {
    description: "Sample of 20 shoppers with matching first and last name initials, showing full name, age, monogram, and country."
    dimensions: [
      users.id,
      users.first_name,
      users.last_name,
      users.age,
      users.monogram,
      users.country
    ]
    filters: [users.is_alliterative_name: "yes"]
    sorts: [
      users.first_name: asc,
      users.last_name: asc
    ]
    limit: 20
  }

  query: top_unnested_name_starting_letters {
    description: "Top 20 given first-name and family surname starting initials ranked by unnested token occurrences."
    dimensions: [
      users__name_tokens.name_slot,
      users__name_tokens.starting_letter
    ]
    measures: [users__name_tokens.count]
    sorts: [users__name_tokens.count: desc]
    limit: 20
  }
}
