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

test: users_2024_01_01_young_customers_metrics {
  explore_source: users {
    column: user_count { field: users.count }
    column: avg_customer_age { field: users.avg_customer_age }
    column: youngest_shopper_age { field: users.youngest_shopper_age }
    column: oldest_shopper_age { field: users.oldest_shopper_age }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
    filters: {
      field: users.is_young_customer
      value: "yes"
    }
  }
  assert: young_customer_count_matches {
    expression: ${users.count} = 5 ;;
  }
  assert: avg_young_customer_age_matches {
    expression: round(${users.avg_customer_age}, 2) = 19.2 ;;
  }
  assert: youngest_young_customer_age_matches {
    expression: ${users.youngest_shopper_age} = 12 ;;
  }
  assert: oldest_young_customer_under_25 {
    expression: ${users.oldest_shopper_age} = 24 ;;
  }
}

test: users_2024_01_01_new_customer_created_year_metrics {
  explore_source: users {
    column: cohort_signup_year { field: users.cohort_signup_year }
    column: user_count { field: users.count }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
  }
  assert: signup_year_matches_2024 {
    expression: ${users.cohort_signup_year} = 2024 ;;
  }
  assert: user_count_matches {
    expression: ${users.count} = 38 ;;
  }
}

test: users_2024_01_01_thoroughfare_tier_metrics {
  explore_source: users {
    column: thoroughfare_tier { field: users.thoroughfare_tier }
    column: user_count { field: users.count }
    column: avg_customer_age { field: users.avg_customer_age }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
    sorts: [users.thoroughfare_tier: asc]
  }
  assert: cul_de_sac_tier_matches {
    expression: index(${users.thoroughfare_tier}, 1) = "2. Cul-de-Sac Court Royalty" AND index(${users.count}, 1) = 8 AND round(index(${users.avg_customer_age}, 1), 2) = 44 ;;
  }
  assert: standard_street_tier_matches {
    expression: index(${users.thoroughfare_tier}, 2) = "3. Standard Street & Road Citizen" AND index(${users.count}, 2) = 5 AND round(index(${users.avg_customer_age}, 2), 2) = 26.2 ;;
  }
  assert: mystery_lane_tier_matches {
    expression: index(${users.thoroughfare_tier}, 3) = "4. Mystery Lane / International Address" AND index(${users.count}, 3) = 25 AND round(index(${users.avg_customer_age}, 3), 2) = 46.96 ;;
  }
  assert: total_slice_users_matches {
    expression: sum(${users.count}) = 38 ;;
  }
}

test: users_2024_01_01_hemisphere_belt_metrics {
  explore_source: users {
    column: hemisphere_belt { field: users.hemisphere_belt }
    column: longitude_sector { field: users.longitude_sector }
    column: count { field: users.count }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
    sorts: [users.hemisphere_belt: asc, users.longitude_sector: asc]
  }
  assert: frost_belt_europe_africa_matches {
    expression: index(${users.hemisphere_belt}, 1) = "1. Northern High-Latitude Frost Belt (>=50N)" AND index(${users.longitude_sector}, 1) = "Europe/Africa Prime" AND index(${users.count}, 1) = 4 ;;
  }
  assert: northern_temperate_sectors_match {
    expression: index(${users.hemisphere_belt}, 2) = "2. Northern Temperate Fashion Zone (23.5N to 50N)" AND index(${users.longitude_sector}, 2) = "Americas West" AND index(${users.count}, 2) = 9 AND index(${users.longitude_sector}, 3) = "Asia/Oceania East" AND index(${users.count}, 3) = 8 AND index(${users.longitude_sector}, 4) = "Europe/Africa Prime" AND index(${users.count}, 4) = 5 ;;
  }
  assert: equatorial_tropics_sectors_match {
    expression: index(${users.hemisphere_belt}, 5) = "3. Equatorial Tropics (-23.5S to 23.5N)" AND index(${users.longitude_sector}, 5) = "Americas West" AND index(${users.count}, 5) = 5 AND index(${users.longitude_sector}, 6) = "Asia/Oceania East" AND index(${users.count}, 6) = 3 ;;
  }
  assert: southern_hemisphere_sectors_match {
    expression: index(${users.hemisphere_belt}, 7) = "4. Southern Hemisphere Down-Under (<-23.5S)" AND index(${users.longitude_sector}, 7) = "Americas West" AND index(${users.count}, 7) = 2 AND index(${users.longitude_sector}, 8) = "Asia/Oceania East" AND index(${users.count}, 8) = 2 ;;
  }
}
