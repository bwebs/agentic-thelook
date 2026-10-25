include: "/bronze/explores/users_base.explore.lkml"

view: user_cohort_facts {
  label: "User Cohort Facts"

  derived_table: {
    explore_source: users_base {
      column: cohort_signup_year { field: users.cohort_signup_year }
      column: cohort_user_count { field: users.count }
    }
  }

  dimension: cohort_signup_year {
    primary_key: yes
    hidden: yes
    description: "Calendar year (UTC) in which the customer cohort first signed up."
    type: number
    value_format_name: id
    sql: ${TABLE}.cohort_signup_year ;;
  }

  dimension: cohort_user_count {
    hidden: yes
    description: "Total registered customers who originally signed up in this cohort calendar year."
    type: number
    sql: ${TABLE}.cohort_user_count ;;
  }

  measure: initial_cohort_users {
    label: "Initial Cohort Users"
    description: "Fixed initial number of customers who signed up in the cohort calendar year, independent of subsequent purchase activity."
    synonyms: ["original cohort users", "initial cohort size", "cohort users"]
    type: sum
    sql: ${cohort_user_count} ;;
  }
}
