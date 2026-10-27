include: "../products.view.lkml"
include: "../products.refinement.lkml"
include: "../products__name_tokens.view.lkml"

explore: products_base {
  label: "Products"
  view_name: products
  hidden: yes

  join: products__name_tokens {
    view_label: "Products: Title Words"
    sql: LEFT JOIN UNNEST(${products.name_tokens}) AS products__name_tokens WITH OFFSET AS products__name_tokens_offset ;;
    relationship: one_to_many
  }
}
