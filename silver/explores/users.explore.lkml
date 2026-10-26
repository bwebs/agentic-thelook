include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/users__name_tokens.view.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"
include: "/bronze/explores/users_base.explore.lkml"
include: "/silver/order_items_users_fields.view.lkml"
include: "/silver/orders_users_fields.view.lkml"
include: "/silver/events_order_items_fields.view.lkml"
include: "/silver/user_cohort_facts.view.lkml"
include: "/silver/order_items_user_cohort_facts_fields.view.lkml"
include: "/silver/user_spend_facts.view.lkml"
include: "/silver/user_order_facts.view.lkml"
include: "/silver/user_order_facts_users_fields.view.lkml"
include: "/silver/user_spend_trajectory_facts.view.lkml"
include: "/silver/user_click_facts.view.lkml"
include: "/silver/user_click_facts_user_spend_facts_users_fields.view.lkml"

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

  join: events {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${events.user_id} ;;
  }

  join: events_order_items_fields {
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

  join: user_spend_facts {
    view_label: "Customer Spend Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${user_spend_facts.user_id} ;;
  }

  join: user_order_facts {
    view_label: "Customer Order Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
  }

  join: user_spend_trajectory_facts {
    view_label: "Customer Spend Trajectory Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${user_spend_trajectory_facts.user_id} AND ${user_spend_trajectory_facts.order_recency_rank} = 1 ;;
  }

  join: user_click_facts {
    view_label: "Customer Clickstream Facts"
    type: left_outer
    relationship: one_to_one
    sql_on: ${users.id} = ${user_click_facts.user_id} ;;
  }

  join: user_click_facts_user_spend_facts_users_fields {
    view_label: "Users"
    sql: ;;
    relationship: one_to_one
  }

  join: user_order_facts_users_fields {
    view_label: "Customer Order Facts"
    sql: ;;
    relationship: one_to_one
  }

  query: customers_by_activation_velocity_persona {
    description: "Paying customer count, average customer age, and average days from signup to first order across Same-Day Signup-to-Swipe Impulse Buyer versus Slow Burner personas."
    dimensions: [user_order_facts_users_fields.activation_velocity_persona]
    measures: [
      users.count,
      users.avg_customer_age,
      user_order_facts_users_fields.avg_days_to_first_order
    ]
    filters: [user_order_facts.user_id: "NOT NULL"]
    sorts: [user_order_facts_users_fields.activation_velocity_persona: asc]
  }

  query: signup_to_order_lag_by_traffic_source {
    description: "Buying user count and average days from signup to order across acquisition traffic sources for post-signup orders."
    dimensions: [users.traffic_source]
    measures: [
      users.count,
      orders_users_fields.avg_days_from_signup_to_order
    ]
    filters: [orders_users_fields.is_post_signup_order: "yes"]
    sorts: [orders_users_fields.avg_days_from_signup_to_order: asc]
  }

  query: customers_by_return_behavior_persona {
    description: "Paying customer count, average age, items bought, items returned, and gross spend at risk across Chronic Boomerang Wardrober personas."
    dimensions: [user_spend_facts.return_behavior_persona]
    measures: [
      users.count,
      users.avg_customer_age,
      order_items.count,
      order_items.ever_returned_items,
      order_items.total_revenue
    ]
    filters: [user_spend_facts.user_id: "NOT NULL"]
    sorts: [user_spend_facts.return_behavior_persona: asc]
  }

  query: top_boomerang_wardrobers {
    description: "Top 15 habitual 100%-return wardrobers with 3+ items ordered ranked by total refunded spend."
    dimensions: [
      users.id,
      users.full_name,
      users.age,
      users.country
    ]
    measures: [
      order_items.count,
      order_items.total_revenue
    ]
    filters: [
      user_spend_facts.return_behavior_persona: "Free-Rental Boomerang Wardrober (100^% Returned)",
      order_items.count: ">=3"
    ]
    sorts: [order_items.total_revenue: desc]
    limit: 15
  }

  query: customers_by_margin_archetype {
    description: "Paying customer count, average age, group revenue, group profit, and blended gross profit margin across Margin Vampire versus High-Margin Profit Angel archetypes."
    dimensions: [user_spend_facts.customer_margin_archetype]
    measures: [
      users.count,
      users.avg_customer_age,
      user_spend_facts.total_lifetime_spend,
      user_spend_facts.total_lifetime_profit,
      user_spend_facts.blended_lifetime_margin_ratio
    ]
    filters: [user_spend_facts.user_id: "NOT NULL"]
    sorts: [user_spend_facts.customer_margin_archetype: asc]
  }

  query: customers_by_national_wealth_tier {
    description: "Paying customer count, average age, distinct countries covered, average customer LTV, and total tier revenue across Country-Relative Wealth Quartile Tiers."
    dimensions: [user_spend_facts.national_wealth_tier]
    measures: [
      users.count,
      users.avg_customer_age,
      users.distinct_countries,
      user_spend_facts.avg_customer_ltv,
      order_items.total_revenue
    ]
    filters: [user_spend_facts.user_id: "NOT NULL"]
    sorts: [user_spend_facts.national_wealth_tier: asc]
  }

  query: top_spender_by_country {
    description: "National #1 top-spending customer leaderboard across every country ranked by lifetime spend."
    dimensions: [
      users.country,
      users.full_name,
      users.age,
      user_spend_facts.lifetime_spend,
      user_spend_facts.country_spend_rank
    ]
    filters: [user_spend_facts.country_spend_rank: "1"]
    sorts: [user_spend_facts.lifetime_spend: desc]
  }

  query: repeat_customers_by_spend_trajectory {
    description: "Repeat customer count, average first order spend, and average latest order spend across Customer Spend Trajectory Personas."
    dimensions: [user_spend_trajectory_facts.spend_trajectory_persona]
    measures: [
      users.count,
      user_spend_trajectory_facts.avg_first_order_spend,
      user_spend_trajectory_facts.avg_latest_order_spend
    ]
    filters: [user_spend_trajectory_facts.user_order_count: ">=2"]
    sorts: [user_spend_trajectory_facts.spend_trajectory_persona: asc]
  }

  query: customers_by_clickstream_intent_persona {
    description: "Registered customer count, average customer age, average lifetime clicks, and average lifetime items bought across Clickstream Tease versus Sniping Assassin personas."
    dimensions: [user_click_facts_user_spend_facts_users_fields.clickstream_intent_persona]
    measures: [
      users.count,
      users.avg_customer_age,
      user_click_facts_user_spend_facts_users_fields.avg_user_clicks,
      user_click_facts_user_spend_facts_users_fields.avg_user_items_bought
    ]
    sorts: [user_click_facts_user_spend_facts_users_fields.clickstream_intent_persona: asc]
  }

  query: high_click_shoppers_clicks_per_item {
    description: "Top 15 high-click customers (25+ lifetime clicks) ranked by clicks per item bought and total clicks."
    dimensions: [
      users.id,
      users.first_name,
      users.last_name,
      users.age,
      users.country
    ]
    measures: [
      events.count,
      events.unique_chaotic_sessions,
      order_items.count,
      events_order_items_fields.clicks_per_item_bought
    ]
    filters: [
      events.id: "NOT NULL",
      events.count: ">=25"
    ]
    sorts: [
      events_order_items_fields.clicks_per_item_bought: desc,
      events.count: desc
    ]
    limit: 15
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

  query: customers_by_oceanic_spend_tier {
    description: "Paying customer count, average buyer age, total tier revenue, and average customer LTV across Whale versus Minnow Customer Spend Tiers."
    dimensions: [user_spend_facts.oceanic_spend_tier]
    measures: [
      users.count,
      users.avg_customer_age,
      order_items.total_revenue,
      user_spend_facts.avg_customer_ltv
    ]
    filters: [user_spend_facts.user_id: "NOT NULL"]
    sorts: [user_spend_facts.oceanic_spend_tier: asc]
  }

  query: top_mega_whale_customers {
    description: "Top 20 Moby Dick Mega-Whale customers ($300+ lifetime spend) ranked by cumulative lifetime spend."
    dimensions: [
      users.id,
      users.full_name,
      users.age,
      users.country
    ]
    measures: [
      order_items.count,
      order_items.total_revenue
    ]
    filters: [
      order_items.id: "NOT NULL",
      order_items.total_revenue: ">=300"
    ]
    sorts: [order_items.total_revenue: desc]
    limit: 20
  }

  query: customers_by_loyalty_tier {
    description: "Registered customer count, average customer age, orders contributed, and items contributed across One-and-Done Tourist versus Loyal Repeat Regular tiers."
    dimensions: [user_order_facts.customer_loyalty_tier]
    measures: [
      users.count,
      users.avg_customer_age,
      orders.count,
      orders.total_items
    ]
    sorts: [user_order_facts.customer_loyalty_tier: asc]
  }

  query: top_loyal_repeat_regulars {
    description: "Top 20 Cult Die-Hard Regular customers (3+ lifetime orders) ranked by total orders and total items ordered."
    dimensions: [
      users.id,
      users.full_name,
      users.age,
      users.country
    ]
    measures: [
      orders.count,
      orders.total_items
    ]
    filters: [
      orders.order_id: "NOT NULL",
      orders.count: ">=3"
    ]
    sorts: [
      orders.count: desc,
      orders.total_items: desc
    ]
    limit: 20
  }
}
