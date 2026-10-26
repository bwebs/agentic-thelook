include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/explores/products_base.explore.lkml"
include: "/silver/order_items_products_fields.view.lkml"

explore: products_sales_base {
  extends: [products_base]
  view_name: products
  hidden: yes

  join: order_items {
    type: left_outer
    relationship: one_to_many
    sql_on: ${products.id} = ${order_items.product_id} ;;
  }

  join: order_items_products_fields {
    view_label: "Products"
    sql: ;;
    relationship: one_to_one
    fields: [pk, avg_activity_weighted_retail_price]
  }
}
