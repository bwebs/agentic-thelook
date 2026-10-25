include: "../../silver/explores/users.explore.lkml"

test: users_refinement_metrics {
  explore_source: users {
    column: avg_customer_age { field: users.avg_customer_age }
    column: youngest_shopper_age { field: users.youngest_shopper_age }
    column: oldest_shopper_age { field: users.oldest_shopper_age }
    column: user_count { field: users.count }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
  }
  assert: avg_customer_age_matches {
    expression: round(${users.avg_customer_age}, 2) = 39.52 ;;
  }
  assert: youngest_shopper_age_matches {
    expression: ${users.youngest_shopper_age} = 14 ;;
  }
  assert: oldest_shopper_age_matches {
    expression: ${users.oldest_shopper_age} = 70 ;;
  }
  assert: user_count_matches {
    expression: ${users.count} = 29 ;;
  }
}

test: users_2024_01_01_latitude_metrics {
  explore_source: users {
    column: user_count { field: users.count }
    column: avg_abs_latitude { field: users.avg_abs_latitude }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
  }
  assert: user_count_matches {
    expression: ${users.count} = 33 ;;
  }
  assert: avg_abs_latitude_matches {
    expression: round(${users.avg_abs_latitude}, 2) = 37.3 ;;
  }
}
