include: "../users.view.lkml"
include: "../users.refinement.lkml"
include: "../users__name_tokens.view.lkml"

explore: users_base {
  label: "Users"
  view_name: users
  hidden: yes

  join: users__name_tokens {
    view_label: "Users: Name Tokens"
    sql: LEFT JOIN UNNEST(${users.name_tokens}) AS users__name_tokens WITH OFFSET AS users__name_tokens_offset ;;
    relationship: one_to_many
  }

  query: avg_customer_age {
    description: "Average Customer Wisdom Level measures the mean age of our registered shopper base alongside the youngest and oldest customers on file. The social media marketing team checks this demographic pulse to decide how much creative budget goes toward youth channels versus older audiences."
    measures: [users.avg_customer_age, users.youngest_shopper_age, users.oldest_shopper_age]
  }
}
