include: "/bronze/common_helpers.view.lkml"
include: "/silver/user_purchase_recency_facts.view.lkml"

explore: user_purchase_recency_base {
  view_name: user_purchase_recency_facts
  hidden: yes
  cancel_grouping_fields: [common_helpers.no_group]

  join: common_helpers {
    sql: ;;
    relationship: one_to_one
  }
}
