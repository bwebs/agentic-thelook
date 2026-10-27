include: "/bronze/explores/order_items_base.explore.lkml"

view: monthly_revenue_facts {
  label: "Monthly Revenue Momentum Facts"

  derived_table: {
    explore_source: order_items_base {
      column: created_month { field: order_items.created_month }
      column: orders_count { field: order_items.distinct_orders }
      column: items_count { field: order_items.count }
      column: monthly_revenue { field: order_items.total_revenue }
      derived_column: prev_month_revenue {
        sql: LAG(monthly_revenue) OVER (ORDER BY created_month ASC) ;;
      }
      derived_column: rolling_3m_avg_revenue {
        sql: AVG(monthly_revenue) OVER (ORDER BY created_month ASC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) ;;
      }
      derived_column: cumulative_all_time_revenue {
        sql: SUM(monthly_revenue) OVER (ORDER BY created_month ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) ;;
      }
    }
  }

  dimension: created_month {
    primary_key: yes
    label: "Order Month"
    description: "Calendar year-month (YYYY-MM, UTC) of order item creation."
    synonyms: ["ym", "year month", "revenue month"]
    type: string
    sql: FORMAT_TIMESTAMP('%Y-%m', ${TABLE}.created_month) ;;
  }

  dimension: orders_count {
    label: "Monthly Orders Count"
    group_label: "Monthly Volume & Revenue"
    description: "Distinct orders placed during the calendar month."
    synonyms: ["monthly distinct orders", "orders in month"]
    type: number
    sql: ${TABLE}.orders_count ;;
  }

  dimension: items_count {
    label: "Monthly Items Count"
    group_label: "Monthly Volume & Revenue"
    description: "Total order line items placed during the calendar month."
    synonyms: ["monthly items sold", "items in month"]
    type: number
    sql: ${TABLE}.items_count ;;
  }

  dimension: monthly_revenue {
    label: "Monthly Gross Revenue"
    group_label: "Monthly Volume & Revenue"
    description: "Total gross dollar sales generated during the calendar month."
    synonyms: ["monthly sales", "month revenue"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.monthly_revenue ;;
  }

  dimension: prev_month_revenue {
    label: "Prior Month Revenue"
    group_label: "Rolling Momentum & Whiplash"
    description: "Gross dollar sales from the immediately preceding calendar month."
    synonyms: ["previous month revenue", "prior month sales"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.prev_month_revenue ;;
  }

  dimension: mom_revenue_growth_rate {
    label: "MoM Revenue Whiplash Growth Rate"
    group_label: "Rolling Momentum & Whiplash"
    description: "Month-over-month sales growth swing ratio comparing current monthly revenue against the prior month ((monthly_revenue - prev_month_revenue) / prev_month_revenue)."
    synonyms: ["mom whiplash pct", "month over month revenue growth", "monthly revenue whiplash"]
    type: number
    value_format_name: percent_2
    sql: SAFE_DIVIDE(${monthly_revenue} - ${prev_month_revenue}, NULLIF(${prev_month_revenue}, 0)) ;;
  }

  dimension: rolling_3m_avg_revenue {
    label: "Rolling 3-Month Average Revenue"
    group_label: "Rolling Momentum & Whiplash"
    description: "Smoothed three-month trailing moving average of monthly gross revenue (current month and two preceding months)."
    synonyms: ["rolling 3m avg revenue", "three-month moving average revenue", "rolling momentum revenue"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.rolling_3m_avg_revenue ;;
  }

  dimension: cumulative_all_time_revenue {
    label: "Cumulative All-Time Revenue"
    group_label: "Rolling Momentum & Whiplash"
    description: "Running cumulative all-time gross dollar revenue from the store's first month through the evaluated month."
    synonyms: ["cumulative revenue", "running total all-time revenue"]
    type: number
    value_format_name: usd
    sql: ${TABLE}.cumulative_all_time_revenue ;;
  }

  measure: count {
    label: "Evaluated Months"
    description: "Count of evaluated calendar months."
    synonyms: ["months count", "evaluated month count"]
    type: count
  }

  measure: total_monthly_revenue {
    label: "Total Revenue Across Selected Months"
    description: "Sum of monthly gross revenue across selected calendar months."
    synonyms: ["selected months revenue"]
    type: sum
    value_format_name: usd
    sql: ${monthly_revenue} ;;
  }
}
