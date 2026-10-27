include: "/silver/explores/order_items.explore.lkml"

view: user_spend_facts {
  label: "Customer Spend Facts"

  derived_table: {
    explore_source: order_items {
      column: user_id { field: order_items.user_id }
      column: country { field: users.country }
      column: items_bought { field: order_items.count }
      column: mens_items_bought { field: order_items_products_fields.mens_units }
      column: womens_items_bought { field: order_items_products_fields.womens_units }
      column: items_returned { field: order_items.ever_returned_items }
      column: lifetime_returned_dollars { field: order_items.ever_returned_revenue }
      column: status_returned_items { field: order_items.returned_items }
      column: lifetime_spend { field: order_items.total_revenue }
      column: lifetime_profit { field: inventory_items_order_items_fields.total_gross_profit }
      column: retained_net_profit { field: inventory_items_order_items_fields.retained_net_profit }
      filters: [order_items.user_id: "NOT NULL"]
      derived_column: country_spend_quartile {
        sql: NTILE(4) OVER (PARTITION BY country ORDER BY lifetime_spend DESC) ;;
      }
      derived_column: country_spend_rank {
        sql: RANK() OVER (PARTITION BY country ORDER BY lifetime_spend DESC) ;;
      }
    }
  }

  dimension: user_id {
    primary_key: yes
    label: "Paying Customer User ID"
    description: "Unique customer identifier for shoppers who have purchased at least one order item."
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: country {
    hidden: yes
    type: string
    sql: ${TABLE}.country ;;
  }

  dimension: items_bought {
    label: "Customer Lifetime Items Bought"
    description: "Cumulative number of order items purchased across the customer's lifetime."
    synonyms: ["items bought", "lifetime items purchased"]
    type: number
    sql: ${TABLE}.items_bought ;;
  }

  dimension: mens_items_bought {
    label: "Customer Lifetime Menswear Items Bought"
    group_label: "Department Allegiance"
    description: "Cumulative number of order items purchased in the 'Men' product department across the customer's lifetime."
    synonyms: ["mens items", "customer menswear units"]
    type: number
    sql: ${TABLE}.mens_items_bought ;;
  }

  dimension: womens_items_bought {
    label: "Customer Lifetime Womenswear Items Bought"
    group_label: "Department Allegiance"
    description: "Cumulative number of order items purchased in the 'Women' product department across the customer's lifetime."
    synonyms: ["womens items", "customer womenswear units"]
    type: number
    sql: ${TABLE}.womens_items_bought ;;
  }

  dimension: department_allegiance {
    label: "Department Loyalist versus Cross-Department Switch-Hitter"
    group_label: "Department Allegiance"
    description: "Department Loyalist versus Cross-Department Switch-Hitter classifies customers and high-volume postal codes by whether their purchases stay strictly inside the Men's department, stay strictly inside the Women's department, or cross over between both departments (returns NULL for non-purchasing accounts). Email newsletter editors use this department allegiance tag to decide who receives the menswear lookbook, the womenswear lookbook, or the combined household edition."
    synonyms: ["department allegiance term", "department loyalist vs cross-department switch-hitter", "department allegiance", "menswear vs womenswear loyalist"]
    case: {
      when: {
        sql: ${mens_items_bought} > 0 AND ${womens_items_bought} = 0 ;;
        label: "Strictly Menswear Purist"
      }
      when: {
        sql: ${user_id} IS NOT NULL AND ${mens_items_bought} = 0 ;;
        label: "Strictly Womenswear Purist"
      }
      when: {
        sql: ${mens_items_bought} > 0 AND ${womens_items_bought} > 0 ;;
        label: "Cross-Department Switch-Hitter (Buys Both Men & Women)"
      }
    }
  }

  dimension: lifetime_spend {
    label: "Customer Lifetime Spend"
    description: "Cumulative gross dollar spend across all order items purchased by the customer."
    synonyms: ["lifetime spend", "customer ltv", "cumulative spend", "total spend"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.lifetime_spend ;;
  }

  dimension: oceanic_spend_tier {
    label: "Whale versus Minnow Customer Spend Tier"
    description: "Whale versus Minnow Customer Spend Tier segments paying customers by their cumulative lifetime dollar spend into four oceanic brackets: 'Plankton (<$30 LTV)', 'Minnow ($30-$99 LTV)', 'Dolphin ($100-$299 LTV)', and 'Moby Dick Mega-Whale ($300+ LTV)' (returns NULL for non-purchasing accounts). Customer service and loyalty teams use this spend tier to route Mega-Whales to priority support and exclusive VIP perks."
    synonyms: ["oceanic spend tier", "whale vs minnow customer spend tier", "customer spend tier", "ltv spend bracket"]
    case: {
      when: {
        sql: ${lifetime_spend} < 30.0 ;;
        label: "Plankton (<$30 LTV)"
      }
      when: {
        sql: ${lifetime_spend} < 100.0 ;;
        label: "Minnow ($30-$99 LTV)"
      }
      when: {
        sql: ${lifetime_spend} < 300.0 ;;
        label: "Dolphin ($100-$299 LTV)"
      }
      when: {
        sql: ${lifetime_spend} >= 300.0 ;;
        label: "Moby Dick Mega-Whale ($300+ LTV)"
      }
    }
  }

  dimension: items_returned {
    label: "Customer Lifetime Items Returned"
    group_label: "Return Behavior"
    description: "Cumulative number of purchased order items that the customer ended up returning."
    synonyms: ["customer items returned", "lifetime boomeranged items"]
    type: number
    sql: ${TABLE}.items_returned ;;
  }

  dimension: lifetime_return_rate {
    label: "Customer Lifetime Return Rate"
    group_label: "Return Behavior"
    description: "Share of cumulative purchased items that the customer ended up returning."
    synonyms: ["customer return rate", "buyer return share"]
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${items_returned}, ${items_bought}) ;;
  }

  dimension: return_behavior_persona {
    label: "Chronic Boomerang Wardrober"
    group_label: "Return Behavior"
    description: "Chronic Boomerang Wardrober classifies paying customers by the share of their purchased items they end up returning: Keep-Everything Angels with zero returns, Selective Sizers who return less than half their items, Indecisive Coin-Flippers who return at least half, and Free-Rental Boomerang Wardrobers who have returned 100 percent of everything they ever bought (returns NULL for non-purchasing accounts). Returns and risk teams use this persona to flag habitual wardrobers and offer virtual sizing assistance."
    synonyms: ["return behavior persona", "chronic boomerang wardrober", "boomerang wardrober persona", "customer return persona"]
    case: {
      when: {
        sql: ${items_returned} = 0 ;;
        label: "Keep-Everything Angel (0% Returned)"
      }
      when: {
        sql: ${items_returned} < ${items_bought} AND ${lifetime_return_rate} < 0.5 ;;
        label: "Selective Sizer (1-49% Returned)"
      }
      when: {
        sql: ${items_returned} < ${items_bought} ;;
        label: "Indecisive Coin-Flipper (50-99% Returned)"
      }
      when: {
        sql: ${user_id} IS NOT NULL ;;
        label: "Free-Rental Boomerang Wardrober (100% Returned)"
      }
    }
  }

  dimension: lifetime_profit {
    label: "Customer Lifetime Gross Profit"
    group_label: "Profitability"
    description: "Cumulative gross dollar profit across all order items purchased by the customer."
    synonyms: ["customer lifetime profit", "user total profit"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.lifetime_profit ;;
  }

  dimension: lifetime_margin_ratio {
    label: "Customer Lifetime Gross Margin"
    group_label: "Profitability"
    description: "Blended gross profit margin across everything in the customer's shopping history (lifetime_profit / lifetime_spend)."
    synonyms: ["customer margin ratio", "lifetime gross margin share"]
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${lifetime_profit}, ${lifetime_spend}) ;;
  }

  dimension: customer_margin_archetype {
    label: "Margin Vampire versus High-Margin Profit Angel"
    group_label: "Profitability"
    description: "Margin Vampire versus High-Margin Profit Angel classifies paying customers by the blended gross profit margin of everything in their shopping history, separating Margin Vampires under 45 percent margin from Standard Margin Citizens and High-Margin Profit Angels above 55 percent margin (returns NULL for non-purchasing accounts). Promotional targeting systems use this profitability tier to hold back heavy discount codes from low-margin buyers while sending VIP rewards to high-margin angels."
    synonyms: ["customer margin archetype", "margin vampire vs high-margin profit angel", "margin vampire persona", "profit angel tier"]
    case: {
      when: {
        sql: ${lifetime_margin_ratio} < 0.45 ;;
        label: "Margin Vampire Customer (<45% Gross Margin)"
      }
      when: {
        sql: ${lifetime_margin_ratio} < 0.55 ;;
        label: "Standard Margin Citizen (45-55% Gross Margin)"
      }
      when: {
        sql: ${user_id} IS NOT NULL ;;
        label: "High-Margin Profit Angel (55%+ Gross Margin)"
      }
    }
  }

  dimension: country_spend_quartile {
    label: "Country Spend Quartile"
    group_label: "Country Wealth Ranking"
    description: "National customer spend quartile (1 = top 25% spender in country through 4 = bottom 25% buyer in country)."
    synonyms: ["country quartile", "national spend quartile"]
    type: number
    sql: ${TABLE}.country_spend_quartile ;;
  }

  dimension: country_spend_rank {
    label: "Country Spend Rank"
    group_label: "Country Wealth Ranking"
    description: "Competition rank of the customer's cumulative lifetime spend among all buyers in their country (1 = top national spender)."
    synonyms: ["rank in country", "national spender rank", "country top spender rank"]
    type: number
    sql: ${TABLE}.country_spend_rank ;;
  }

  dimension: national_wealth_tier {
    label: "Country-Relative Wealth Quartile Tier"
    group_label: "Country Wealth Ranking"
    description: "Country-Relative Wealth Quartile Tier ranks customers against other buyers inside their own country rather than against a single global dollar cutoff, dividing each nation's shoppers into National Fashion Oligarchs in the top quarter, Upper-Middle National Shoppers, Modest Local Regulars, and National Entry-Level Buyers (returns NULL for non-purchasing accounts). International country managers use these local quartiles and the national top-spender leaderboard to recognize VIP customers in every market regardless of local market size."
    synonyms: ["national wealth tier", "country-relative wealth quartile tier", "country wealth quartile", "national fashion oligarch tier"]
    case: {
      when: {
        sql: ${country_spend_quartile} = 1 ;;
        label: "National Fashion Oligarch (Top 25% in Country)"
      }
      when: {
        sql: ${country_spend_quartile} = 2 ;;
        label: "Upper-Middle National Shopper (25-50%)"
      }
      when: {
        sql: ${country_spend_quartile} = 3 ;;
        label: "Modest Local Regular (50-75%)"
      }
      when: {
        sql: ${user_id} IS NOT NULL ;;
        label: "National Entry-Level Buyer (Bottom 25%)"
      }
    }
  }

  measure: avg_customer_ltv {
    label: "Average Customer LTV"
    description: "Average cumulative lifetime dollar spend across paying customers."
    synonyms: ["tier avg ltv", "average lifetime spend", "avg buyer ltv", "avg spend"]
    tags: ["non_additive"]
    type: average
    sql: ${lifetime_spend} ;;
    value_format_name: usd
  }

  measure: total_items_bought {
    label: "Total Customer Lifetime Items Bought"
    description: "Cumulative number of order items purchased summed across paying customers."
    synonyms: ["total items bought", "buyer items bought"]
    type: sum
    sql: ${items_bought} ;;
  }

  measure: total_lifetime_spend {
    label: "Total Customer Lifetime Spend"
    description: "Cumulative gross dollar revenue summed across paying customers."
    synonyms: ["group revenue", "total buyer spend"]
    type: sum
    sql: ${lifetime_spend} ;;
    value_format_name: usd
  }

  measure: total_lifetime_profit {
    label: "Total Customer Lifetime Gross Profit"
    description: "Cumulative gross dollar profit summed across paying customers."
    synonyms: ["group profit", "total buyer profit"]
    type: sum
    sql: ${lifetime_profit} ;;
    value_format_name: usd
  }

  measure: blended_lifetime_margin_ratio {
    label: "Blended Customer Gross Margin"
    description: "Blended gross profit margin share across paying customers (total customer lifetime profit divided by total customer lifetime spend)."
    synonyms: ["blended customer margin", "cohort gross margin share"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${total_lifetime_profit} / NULLIF(${total_lifetime_spend}, 0) ;;
    value_format_name: percent_2
  }

  dimension: status_returned_items {
    hidden: yes
    type: number
    sql: COALESCE(${TABLE}.status_returned_items, 0) ;;
  }

  dimension: retained_net_profit {
    label: "Customer Retained Net Profit"
    group_label: "Profitability"
    description: "Cumulative retained net dollar profit across non-reversed order items purchased by the customer (excluding Returned and Cancelled items)."
    synonyms: ["customer retained profit", "retained buyer profit"]
    type: number
    value_format_name: usd
    sql: COALESCE(${TABLE}.retained_net_profit, 0) ;;
  }

  measure: count {
    label: "Active Paying Buyers"
    description: "Number of distinct paying customers who have purchased at least one order item."
    synonyms: ["active buyers", "paying customers count"]
    type: count
    filters: [user_id: "NOT NULL"]
  }

  dimension: lifetime_returned_dollars {
    label: "Customer Lifetime Returned Dollars"
    group_label: "Return Behavior"
    description: "Cumulative sale price of purchased items returned by the customer (status 'Returned' or returned_at populated)."
    synonyms: ["returned dollars", "customer refund dollars", "lifetime refunded spend"]
    type: number
    value_format_name: usd
    sql: COALESCE(${TABLE}.lifetime_returned_dollars, 0) ;;
  }

  dimension: is_serial_returner {
    label: "Serial Returner (2+ Items Returned)"
    group_label: "Return Behavior"
    description: "Whether the customer is a habitual repeat returner who has sent back two or more purchased items."
    synonyms: ["is serial returner", "habitual repeat returner", "serial returner"]
    type: yesno
    sql: ${items_returned} >= 2 ;;
  }

  measure: serial_returner_users {
    label: "Serial Returner Users (2+ Returns)"
    description: "Number of paying customers who have sent back two or more purchased items."
    synonyms: ["serial returner user count", "habitual repeat returners"]
    type: count
    filters: [user_id: "NOT NULL", is_serial_returner: "yes"]
  }

  measure: any_returner_users {
    label: "Returner Users (1+ Returns)"
    description: "Number of paying customers who have sent back at least one purchased item."
    synonyms: ["any returner user count", "returning customers count"]
    type: count
    filters: [user_id: "NOT NULL", items_returned: ">=1"]
  }

  measure: serial_returner_refund_dollars {
    label: "Serial Returner Refund Dollars"
    description: "Total refunded merchandise dollars attributable to habitual repeat returners who have sent back two or more items."
    synonyms: ["serial returner refund dollars", "repeat returner refunded revenue"]
    type: sum
    sql: ${lifetime_returned_dollars} ;;
    filters: [is_serial_returner: "yes"]
    value_format_name: usd
  }

  measure: total_refund_dollars {
    label: "Total Customer Refund Dollars"
    description: "Total refunded merchandise dollars summed across all paying customers."
    synonyms: ["total refund dollars", "all refunded merchandise dollars"]
    type: sum
    sql: ${lifetime_returned_dollars} ;;
    value_format_name: usd
  }

  measure: serial_returner_refund_share {
    label: "Serial Returner Menace Concentration"
    description: "Serial Returner Menace Concentration calculates the share of all refunded merchandise dollars across the business that comes from habitual repeat returners who have sent back two or more items."
    synonyms: ["serial returner share of refunds", "serial returner menace concentration", "repeat returner refund share"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${serial_returner_refund_dollars} / NULLIF(${total_refund_dollars}, 0) ;;
    value_format_name: percent_2
  }
}
