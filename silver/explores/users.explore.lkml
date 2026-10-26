include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
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
    filters: [users.is_new_customer: "yes"]
    sorts: [users.created_time: desc]
    limit: 25
  }
}
