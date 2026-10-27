include: "/silver/explores/user_purchase_recency_base.explore.lkml"

view: user_rfme_facts {
  label: "Customer RFME Super-Score Facts"

  derived_table: {
    explore_source: user_purchase_recency_base {
      column: _no_group { field: common_helpers.no_group }
      column: user_id { field: user_purchase_recency_facts.user_id }
      column: recency_days { field: user_purchase_recency_facts.recency_days }
      column: frequency_orders { field: user_purchase_recency_facts.frequency_orders }
      column: total_items { field: user_purchase_recency_facts.total_items }
      column: gross_monetary { field: user_purchase_recency_facts.gross_monetary }
      column: net_margin_monetary { field: user_purchase_recency_facts.net_margin_monetary }
      column: total_clicks { field: user_purchase_recency_facts.total_clicks }
      derived_column: r_score {
        sql: NTILE(5) OVER (ORDER BY recency_days ASC) ;;
      }
      derived_column: f_score {
        sql: NTILE(5) OVER (ORDER BY frequency_orders DESC, total_items DESC) ;;
      }
      derived_column: m_score {
        sql: NTILE(5) OVER (ORDER BY net_margin_monetary DESC) ;;
      }
      derived_column: e_score {
        sql: NTILE(5) OVER (ORDER BY total_clicks DESC) ;;
      }
    }
  }

  dimension: user_id {
    primary_key: yes
    label: "RFME-Scored Buyer User ID"
    description: "Unique customer identifier for active buyers scored on the 20-point RFME composite scale."
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: recency_days {
    label: "Buyer Recency Days (Dataset Clock)"
    group_label: "RFME Super-Score"
    description: "Whole days elapsed from the buyer's latest item purchase to the latest purchase timestamp in the store ledger."
    type: number
    sql: ${TABLE}.recency_days ;;
  }

  dimension: frequency_orders {
    label: "Buyer Frequency Orders"
    group_label: "RFME Super-Score"
    description: "Distinct orders placed by the buyer."
    type: number
    sql: ${TABLE}.frequency_orders ;;
  }

  dimension: total_items {
    label: "Buyer Total Items"
    group_label: "RFME Super-Score"
    description: "Total order items purchased by the buyer."
    type: number
    sql: ${TABLE}.total_items ;;
  }

  dimension: gross_monetary {
    label: "Buyer Gross Monetary Spend"
    group_label: "RFME Super-Score"
    description: "Cumulative gross dollar spend across order items purchased by the buyer."
    type: number
    value_format_name: usd
    sql: ${TABLE}.gross_monetary ;;
  }

  dimension: net_margin_monetary {
    label: "Buyer Net Margin Monetary"
    group_label: "RFME Super-Score"
    description: "Cumulative gross profit (sale_price - cost) contributed by the buyer."
    type: number
    value_format_name: usd
    sql: ${TABLE}.net_margin_monetary ;;
  }

  dimension: total_clicks {
    label: "Buyer Clickstream Events"
    group_label: "RFME Super-Score"
    description: "Cumulative website clickstream events recorded for the buyer (0 when no clickstream events exist)."
    type: number
    sql: COALESCE(${TABLE}.total_clicks, 0) ;;
  }

  dimension: r_score {
    label: "Recency Quintile Score (1-5)"
    group_label: "RFME Super-Score"
    description: "Buyer recency quintile from 1 (most recent quintile) to 5 (least recent quintile)."
    type: number
    sql: ${TABLE}.r_score ;;
  }

  dimension: f_score {
    label: "Frequency Quintile Score (1-5)"
    group_label: "RFME Super-Score"
    description: "Buyer order frequency quintile from 1 (highest order/item volume quintile) to 5 (lowest volume quintile)."
    type: number
    sql: ${TABLE}.f_score ;;
  }

  dimension: m_score {
    label: "Monetary Margin Quintile Score (1-5)"
    group_label: "RFME Super-Score"
    description: "Buyer net profit contribution quintile from 1 (highest net margin quintile) to 5 (lowest net margin quintile)."
    type: number
    sql: ${TABLE}.m_score ;;
  }

  dimension: e_score {
    label: "Engagement Clicks Quintile Score (1-5)"
    group_label: "RFME Super-Score"
    description: "Buyer clickstream engagement quintile from 1 (most active browsing quintile) to 5 (least active quintile)."
    type: number
    sql: ${TABLE}.e_score ;;
  }

  dimension: composite_rfme_score {
    label: "Customer RFM and Clickstream Engagement Super-Score"
    group_label: "RFME Super-Score"
    description: "Customer RFM and Clickstream Engagement Super-Score grades every buyer on a 4-to-20 composite quintile scale (r_score + f_score + m_score + e_score, where 4 = top quintile across recency, frequency, net margin, and browsing engagement). Retention and VIP marketing teams use this composite score to rank highest-value customers across financial contribution and digital engagement."
    synonyms: [
      "composite rfme score out of 20",
      "rfme super score",
      "customer rfm and clickstream engagement super-score"
    ]
    type: number
    sql: ${r_score} + ${f_score} + ${m_score} + ${e_score} ;;
  }

  measure: count {
    label: "RFME-Scored Buyers"
    description: "Number of active buyers evaluated in the RFME Super-Score breakdown."
    synonyms: ["rfme customer count"]
    type: count
    filters: [user_id: "NOT NULL"]
  }

  measure: avg_recency_days {
    label: "Average Buyer Recency Days"
    description: "Mean elapsed days since latest purchase across RFME-scored buyers."
    synonyms: ["avg recency days"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_1
    sql: ${recency_days} ;;
  }

  measure: avg_frequency_orders {
    label: "Average Buyer Orders"
    description: "Mean distinct orders placed across RFME-scored buyers."
    synonyms: ["avg buyer orders"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_2
    sql: ${frequency_orders} ;;
  }

  measure: avg_gross_spend {
    label: "Average Buyer Gross Spend"
    description: "Mean cumulative gross dollar spend across RFME-scored buyers."
    synonyms: ["avg buyer gross spend"]
    tags: ["non_additive"]
    type: average
    value_format_name: usd
    sql: ${gross_monetary} ;;
  }

  measure: avg_net_margin {
    label: "Average Buyer Net Margin"
    description: "Mean cumulative net profit (sale_price - cost) across RFME-scored buyers."
    synonyms: ["avg net margin"]
    tags: ["non_additive"]
    type: average
    value_format_name: usd
    sql: ${net_margin_monetary} ;;
  }

  measure: avg_buyer_clicks {
    label: "Average Buyer Clicks"
    description: "Mean cumulative website clicks across RFME-scored buyers (counting 0-click buyers as 0)."
    synonyms: ["avg rfme clicks"]
    tags: ["non_additive"]
    type: average
    value_format_name: decimal_1
    sql: ${total_clicks} ;;
  }
}
