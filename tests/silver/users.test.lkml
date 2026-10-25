include: "../../silver/explores/users.explore.lkml"

test: users_2024_01_01_per_capita_spend_metrics {
  explore_source: users {
    column: registered_users { field: users.count }
    column: avg_customer_age { field: users.avg_customer_age }
    column: items_purchased { field: order_items.count }
    column: total_revenue { field: order_items.total_revenue }
    column: revenue_per_registered_user { field: order_items_users_fields.revenue_per_registered_user }
    column: avg_activity_weighted_user_age { field: order_items_users_fields.avg_activity_weighted_user_age }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
  }
  assert: registered_users_matches {
    expression: ${users.count} = 38 ;;
  }
  assert: avg_customer_age_matches {
    expression: round(${users.avg_customer_age}, 2) = 35.45 ;;
  }
  assert: items_purchased_matches {
    expression: ${order_items.count} = 52 ;;
  }
  assert: total_revenue_matches {
    expression: round(${order_items.total_revenue}, 2) = 2623.38 ;;
  }
  assert: revenue_per_registered_user_matches {
    expression: round(${order_items_users_fields.revenue_per_registered_user}, 2) = 69.04 ;;
  }
  assert: avg_activity_weighted_user_age_matches {
    expression: round(${order_items_users_fields.avg_activity_weighted_user_age}, 1) = 39.3 ;;
  }
}
