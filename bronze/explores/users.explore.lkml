include: "../users.view.lkml"
include: "../users.refinement.lkml"

explore: users {
  label: "Users"
  view_name: users
  hidden: no

  query: avg_customer_age {
    description: "Average Customer Wisdom Level measures the mean age of our registered shopper base alongside the youngest and oldest customers on file. The social media marketing team checks this demographic pulse to decide how much creative budget goes toward youth channels versus older audiences."
    measures: [users.avg_customer_age, users.youngest_shopper_age, users.oldest_shopper_age]
  }
}
