include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/users__name_tokens.view.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/explores/users_base.explore.lkml"

explore: users_sales_base {
  extends: [users_base]
  view_name: users
  hidden: yes

  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${users.id} = ${order_items.user_id} ;;
  }
}
