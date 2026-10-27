view: category_sales_facts_order_items_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${order_items.id} ;;
  }

  dimension: price_z_score {
    label: "Purchased Item Price Z-Score"
    group_label: "Fashion Guilt Price-Outlier Analysis"
    description: "Standardized Z-score measuring how many within-category sold-price standard deviations an ordered item's sale price sits above or below its category mean sold price."
    synonyms: ["price z score", "sold price z-score", "fashion guilt z-score"]
    type: number
    value_format_name: decimal_2
    sql: SAFE_DIVIDE(${order_items.sale_price} - ${category_sales_facts.cat_mean_price}, ${category_sales_facts.cat_std_price}) ;;
  }

  dimension: fashion_guilt_sigma_tier {
    label: "Fashion Guilt Price-Outlier Sigma Tier"
    group_label: "Fashion Guilt Price-Outlier Analysis"
    description: "Fashion Guilt Price-Outlier Return Elasticity classifies every purchased item by how many standard deviations its sale price sits above or below its category's normal sold price: Ultra-Splurge Outliers (Z >= +2.0), Treat-Yo-Self Splurges (+1.0 <= Z < +2.0), Normal Sensible Purchases (-0.5 <= Z < +1.0), and Bargain Bin Steals (Z < -0.5). Behavioral analysts and pricing teams use this study to check whether extreme high-price outliers trigger post-purchase buyer's remorse."
    synonyms: [
      "fashion guilt sigma tier",
      "fashion guilt price-outlier return elasticity",
      "splurge sigma tier",
      "price outlier remorse tier"
    ]
    case: {
      when: {
        sql: ${price_z_score} >= 2.0 ;;
        label: "Ultra-Splurge Outlier (Z >= +2.0)"
      }
      when: {
        sql: ${price_z_score} >= 1.0 ;;
        label: "Treat-Yo-Self Splurge (+1.0 <= Z < +2.0)"
      }
      when: {
        sql: ${price_z_score} >= -0.5 ;;
        label: "Normal Sensible Purchase (-0.5 <= Z < +1.0)"
      }
      else: "Bargain Bin Steal (Z < -0.5)"
    }
  }

  measure: avg_category_baseline {
    label: "Average Category Baseline Price"
    description: "Item-weighted average of the category mean sold price across purchased line items."
    synonyms: ["avg category baseline", "average category baseline price"]
    tags: ["non_additive"]
    type: average
    value_format_name: usd
    sql: ${category_sales_facts.cat_mean_price} ;;
  }
}
