include: "/silver/explores/user_brand_facts.explore.lkml"

view: user_brand_entropy_facts {
  label: "Customer Brand Loyalty & Entropy Facts"

  derived_table: {
    explore_source: user_brand_facts {
      column: user_id { field: user_brand_facts.user_id }
      column: total_items { field: user_brand_facts._total_brand_items }
      column: distinct_brands { field: user_brand_facts._brand_count }
      column: total_spend { field: user_brand_facts._total_brand_spend }
      column: total_profit { field: user_brand_facts._total_brand_profit }
      column: brand_shannon_entropy { field: user_brand_facts._sum_brand_entropy }
    }
  }

  dimension: user_id {
    primary_key: yes
    label: "Evaluated Brand Buyer User ID"
    description: "Unique customer identifier for shoppers evaluated on brand purchase entropy."
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_items {
    label: "Customer Closet Total Items"
    group_label: "Brand Loyalty & Entropy"
    description: "Total number of ordered clothing items in the customer's purchase history."
    synonyms: ["items in closet", "user total brand items"]
    type: number
    sql: ${TABLE}.total_items ;;
  }

  dimension: distinct_brands {
    label: "Customer Distinct Brands Bought"
    group_label: "Brand Loyalty & Entropy"
    description: "Number of distinct fashion brands purchased across the customer's shopping history."
    synonyms: ["distinct brands bought", "brands in closet"]
    type: number
    sql: ${TABLE}.distinct_brands ;;
  }

  dimension: total_spend {
    label: "Customer Brand-Evaluated Spend"
    group_label: "Brand Loyalty & Entropy"
    description: "Cumulative gross dollar spend across the customer's brand purchases."
    type: number
    value_format_name: usd
    sql: ${TABLE}.total_spend ;;
  }

  dimension: total_profit {
    label: "Customer Brand-Evaluated Gross Profit"
    group_label: "Brand Loyalty & Entropy"
    description: "Cumulative gross dollar profit across the customer's brand purchases."
    type: number
    value_format_name: usd
    sql: ${TABLE}.total_profit ;;
  }

  dimension: brand_shannon_entropy {
    label: "Brand Loyalty Shannon Entropy"
    group_label: "Brand Loyalty & Entropy"
    description: "Brand Loyalty Monogamy versus Promiscuity Score Shannon entropy (-SUM(p_brand * LN(p_brand))) measuring how widely a customer spreads purchases across fashion brands (0 = single-brand monogamy)."
    synonyms: ["brand shannon entropy", "brand loyalty monogamy vs promiscuity score", "closet brand entropy"]
    type: number
    value_format_name: decimal_4
    sql: GREATEST(${TABLE}.brand_shannon_entropy, 0) ;;
  }

  dimension: closet_entropy_archetype {
    label: "Brand Loyalty Monogamy versus Promiscuity Archetype"
    group_label: "Brand Loyalty & Entropy"
    description: "Brand Loyalty Monogamy versus Promiscuity Score classifies repeat shoppers (3+ items bought) by how widely they spread their purchases across fashion brands: Strictly Brand Monogamous (Entropy = 0), Mostly Loyal Leaning (Entropy < 1.0), Balanced Closet Explorer (1.0 - 1.5), and Hyper-Promiscuous Fashion Chameleon (Entropy >= 1.5) (returns NULL for shoppers with fewer than 3 items). Brand partnership managers compare lifetime spend and profit across these archetypes to evaluate brand-loyal shoppers against variety-seeking closet explorers."
    synonyms: [
      "closet entropy archetype",
      "brand loyalty monogamy versus promiscuity score",
      "brand monogamy vs promiscuity archetype",
      "brand loyalty archetype"
    ]
    case: {
      when: {
        sql: ${total_items} >= 3 AND ${distinct_brands} = 1 ;;
        label: "Strictly Brand Monogamous (Entropy = 0)"
      }
      when: {
        sql: ${total_items} >= 3 AND ${brand_shannon_entropy} < 1.0 ;;
        label: "Mostly Loyal Leaning (Entropy < 1.0)"
      }
      when: {
        sql: ${total_items} >= 3 AND ${brand_shannon_entropy} < 1.5 ;;
        label: "Balanced Closet Explorer (1.0 - 1.5)"
      }
      when: {
        sql: ${total_items} >= 3 ;;
        label: "Hyper-Promiscuous Fashion Chameleon (Entropy >= 1.5)"
      }
    }
  }

  measure: count {
    label: "Evaluated Brand Buyers"
    description: "Count of distinct customers with evaluated brand purchase history."
    synonyms: ["repeat customers", "evaluated brand buyers"]
    type: count
    filters: [user_id: "NOT NULL"]
  }

  measure: avg_items_in_closet {
    label: "Average Items in Closet"
    description: "Average number of cumulative clothing items purchased per customer."
    synonyms: ["avg items in closet", "average closet items"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_2
    sql: ${total_items} ;;
  }

  measure: avg_distinct_brands {
    label: "Average Distinct Brands Bought"
    description: "Average number of distinct fashion brands purchased per customer."
    synonyms: ["avg distinct brands", "average brands bought"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_2
    sql: ${distinct_brands} ;;
  }

  measure: avg_shannon_entropy {
    label: "Average Brand Shannon Entropy"
    description: "Mean Shannon brand diversity entropy score across customers."
    synonyms: ["avg shannon entropy", "average brand entropy"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_3
    sql: ${brand_shannon_entropy} ;;
  }

  measure: avg_buyer_spend {
    label: "Average Brand-Evaluated Lifetime Spend"
    description: "Average cumulative gross dollar spend across brand-evaluated customers."
    synonyms: ["avg lifetime spend", "average buyer spend"]
    tags: ["non_additive"]
    type: average
    value_format_name: usd
    sql: ${total_spend} ;;
  }

  measure: avg_buyer_profit {
    label: "Average Brand-Evaluated Lifetime Profit"
    description: "Average cumulative gross dollar profit across brand-evaluated customers."
    synonyms: ["avg lifetime profit", "average buyer profit"]
    tags: ["non_additive"]
    type: average
    value_format_name: usd
    sql: ${total_profit} ;;
  }
}
