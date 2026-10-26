include: "/silver/explores/products_sales_base.explore.lkml"

view: brand_facts {
  label: "Brand Prestige Facts"

  derived_table: {
    explore_source: products_sales_base {
      column: brand { field: products.brand }
      column: avg_retail_price { field: order_items_products_fields.avg_activity_weighted_retail_price }
      filters: [products.brand: "-NULL"]
    }
  }

  dimension: brand {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: avg_retail_price {
    label: "Brand Average Retail Price"
    description: "Average retail sticker price across the brand's catalog and order activity."
    synonyms: ["brand avg retail price", "brand mean sticker price"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.avg_retail_price ;;
  }

  dimension: brand_prestige_tier {
    label: "Fast-Fashion versus Ultra-Luxury Brand Tier"
    description: "Fast-Fashion versus Ultra-Luxury Brand Tier groups every brand in the catalog by its average retail price into Haute Couture Luxury Houses at 150 dollars and up, Premium Contemporary Brands from 60 to 149 dollars, Mainstream Mall Brands from 25 to 59 dollars, and Fast-Fashion Bargain Staples under 25 dollars. Storefront designers and brand managers use this prestige tier to tailor brand landing page layouts and promotional rules."
    synonyms: ["brand prestige tier", "fast-fashion vs ultra-luxury brand tier", "ultra-luxury brand tier", "brand price prestige tier"]
    case: {
      when: {
        sql: ${avg_retail_price} >= 150.0 ;;
        label: "Haute Couture Luxury House ($150+ Avg)"
      }
      when: {
        sql: ${avg_retail_price} >= 60.0 ;;
        label: "Premium Contemporary Brand ($60-$149 Avg)"
      }
      when: {
        sql: ${avg_retail_price} >= 25.0 ;;
        label: "Mainstream Mall Brand ($25-$59 Avg)"
      }
      else: "Fast-Fashion Bargain Staple (<$25 Avg)"
    }
  }
}
