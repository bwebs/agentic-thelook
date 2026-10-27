include: "/silver/explores/order_items.explore.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/silver/category_sales_facts.view.lkml"
include: "/silver/order_basket_facts.view.lkml"
include: "/gold/order_items_category_cooccurrence.view.lkml"

explore: order_items_category_cooccurrence {
  extends: [order_items]
  label: "Order Items (Market Basket Category Co-Occurrence)"
  view_name: order_items
  hidden: no
  tags: ["gold"]

  join: paired_order_items {
    from: order_items
    view_label: "Paired Basket Order Items"
    type: left_outer
    relationship: many_to_many
    sql_on: ${order_items.order_id} = ${paired_order_items.order_id} ;;
    fields: [
      paired_order_items.id,
      paired_order_items.order_id,
      paired_order_items.product_id
    ]
  }

  join: paired_products {
    from: products
    view_label: "Paired Basket Product"
    type: left_outer
    relationship: many_to_one
    sql_on: ${paired_order_items.product_id} = ${paired_products.id}
      AND ${products.category} < ${paired_products.category} ;;
    fields: [
      paired_products.id,
      paired_products.category,
      paired_products.department,
      paired_products.brand,
      paired_products.name
    ]
  }

  join: paired_category_sales_facts {
    from: category_sales_facts
    view_label: "Paired Basket Product"
    type: left_outer
    relationship: many_to_one
    sql_on: ${paired_products.category} = ${paired_category_sales_facts.category} ;;
    fields: [
      paired_category_sales_facts.category,
      paired_category_sales_facts.category_orders
    ]
  }

  join: order_basket_facts {
    view_label: "Order Basket Composition Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${order_basket_facts.order_id} ;;
    fields: [
      order_basket_facts.order_id,
      order_basket_facts.store_evaluated_orders
    ]
  }

  join: order_items_category_cooccurrence {
    view_label: "Market Basket Category Co-Occurrence"
    sql: ;;
    relationship: one_to_one
  }

  query: top_category_pair_co_occurrence_lift {
    description: "Top 20 clothing category pairs (10+ shared orders) ranked by Market Basket Odd-Couple Co-Occurrence Lift alongside shared pair orders and individual category order counts."
    dimensions: [
      products.category,
      paired_products.category
    ]
    measures: [
      order_items_category_cooccurrence.pair_orders,
      category_sales_facts.category_orders,
      paired_category_sales_facts.category_orders,
      order_items_category_cooccurrence.co_occurrence_lift_score
    ]
    filters: [
      paired_products.id: "NOT NULL",
      order_items_category_cooccurrence.pair_orders: ">=10"
    ]
    sorts: [
      order_items_category_cooccurrence.co_occurrence_lift_score: desc,
      order_items_category_cooccurrence.pair_orders: desc
    ]
    limit: 20
  }
}
