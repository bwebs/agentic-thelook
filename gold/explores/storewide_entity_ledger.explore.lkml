include: "/gold/ojof_none.view.lkml"
include: "/bronze/common_helpers.view.lkml"
include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/bronze/inventory_items.view.lkml"
include: "/bronze/inventory_items.refinement.lkml"
include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"
include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"

explore: storewide_entity_ledger {
  label: "Storewide Multi-Fact Entity Ledger"
  view_name: ojof_none
  hidden: no
  tags: ["gold"]

  join: common_helpers {
    sql: ;;
    relationship: one_to_one
  }

  join: users {
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  join: orders {
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  join: order_items {
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  join: products {
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  join: inventory_items {
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  join: events {
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  join: distribution_centers {
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  query: storewide_seven_table_row_counts {
    description: "Storewide 7-table row count audit across Users, Orders, Order Items, Products, Inventory Items, Clickstream Events, and Distribution Centers."
    measures: [
      users.count,
      orders.count,
      order_items.count,
      products.count,
      inventory_items.count,
      events.count,
      distribution_centers.count
    ]
  }
}
