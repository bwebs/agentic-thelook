include: "../products.view.lkml"
include: "../products.refinement.lkml"

explore: products_base {
  label: "Products (Base)"
  view_name: products
  hidden: yes
}
