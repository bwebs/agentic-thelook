include: "../../bronze/products.view.lkml"
include: "../../bronze/products.refinement.lkml"

explore: products {
  label: "Products"
  view_name: products

  query: avg_sticker_price {
    description: "Average Sticker Shock measures the simple average retail sticker price across every item in our product catalog, regardless of how often it sells. The merchandising team uses this benchmark in board meetings to position the store as an affordable luxury destination."
    measures: [products.avg_sticker_price]
  }
}
