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

test: users_2024_01_01_postal_code_parity_metrics {
  explore_source: users {
    column: postal_code_parity { field: users.postal_code_parity }
    column: count { field: users.count }
    column: distinct_countries { field: users.distinct_countries }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
    sorts: [users.postal_code_parity: asc]
  }
  assert: alphanumeric_postcode_metrics_match {
    expression: index(${users.postal_code_parity}, 1) = "Alphanumeric International Postcode" AND index(${users.count}, 1) = 11 AND index(${users.distinct_countries}, 1) = 3 ;;
  }
  assert: even_zip_aristocrat_metrics_match {
    expression: index(${users.postal_code_parity}, 2) = "Even-Zip Aristocrat" AND index(${users.count}, 2) = 14 AND index(${users.distinct_countries}, 2) = 5 ;;
  }
  assert: odd_zip_rebel_metrics_match {
    expression: index(${users.postal_code_parity}, 3) = "Odd-Zip Rebel" AND index(${users.count}, 3) = 13 AND index(${users.distinct_countries}, 3) = 5 ;;
  }
}

test: users_2024_01_01_age_and_region_metrics {
  explore_source: users {
    column: age_bucket { field: users.age_bucket }
    column: age_decade { field: users.age_decade }
    column: age_decade_label { field: users.age_decade_label }
    column: global_macro_region { field: users.global_macro_region }
    column: us_super_region { field: users.us_super_region }
    column: postal_code_zone { field: users.postal_code_zone }
    column: count { field: users.count }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
    sorts: [
      users.global_macro_region: asc,
      users.us_super_region: asc,
      users.postal_code_zone: asc,
      users.age_bucket: asc,
      users.age_decade: asc
    ]
  }
  assert: north_america_west_coast_row_matches {
    expression: index(${users.global_macro_region}, 1) = "North America" AND index(${users.us_super_region}, 1) = "US West Coast & Pacific" AND index(${users.postal_code_zone}, 1) = "8" AND index(${users.age_bucket}, 1) = "Gen-X Boss (40-54)" AND index(${users.age_decade}, 1) = 50 AND index(${users.age_decade_label}, 1) = "50s Decade" AND index(${users.count}, 1) = 1 ;;
  }
  assert: north_america_sunbelt_row_matches {
    expression: index(${users.global_macro_region}, 5) = "North America" AND index(${users.us_super_region}, 5) = "US Sunbelt & South" AND index(${users.postal_code_zone}, 5) = "3" AND index(${users.age_bucket}, 5) = "Millennial Hustler (25-39)" AND index(${users.age_decade}, 5) = 30 AND index(${users.age_decade_label}, 5) = "30s Decade" AND index(${users.count}, 5) = 2 ;;
  }
  assert: non_us_european_runway_null_us_fields_match {
    expression: index(${users.global_macro_region}, 11) = "European Runway" AND is_null(index(${users.us_super_region}, 11)) AND is_null(index(${users.postal_code_zone}, 11)) AND index(${users.age_bucket}, 11) = "Millennial Hustler (25-39)" AND index(${users.age_decade}, 11) = 20 AND index(${users.age_decade_label}, 11) = "20s Decade" AND index(${users.count}, 11) = 2 ;;
  }
}

test: users_2024_01_name_phonetics_and_tokens {
  explore_source: users {
    column: name_phonetics_club { field: users.name_phonetics_club }
    column: count { field: users.count }
    column: token_count { field: users__name_tokens.count }
    filters: [users.created_date: "2024-01"]
    sorts: [users.name_phonetics_club: asc]
  }
  assert: name_phonetics_club_counts_match {
    expression: index(${users.name_phonetics_club}, 1) = "Marvel Superhero Alliterative Name (Same Initials)"
      AND index(${users.count}, 1) = 66
      AND index(${users.name_phonetics_club}, 2) = "Double-Letter Geminate Name Club"
      AND index(${users.count}, 2) = 375
      AND index(${users.name_phonetics_club}, 3) = "Regular Non-Alliterative Civilian"
      AND index(${users.count}, 3) = 623 ;;
  }
  assert: unnested_name_tokens_double_users {
    expression: ${users__name_tokens.count} = ${users.count} * 2 ;;
  }
}

test: users_id_le_5_full_name_metrics {
  explore_source: users {
    column: id { field: users.id }
    column: full_name { field: users.full_name }
    column: count { field: users.count }
    filters: {
      field: users.id
      value: "<=5"
    }
    sorts: [users.id: asc]
  }
  assert: first_user_full_name_matches {
    expression: index(${users.id}, 1) = 1 AND index(${users.full_name}, 1) = "Valerie Lowe" AND index(${users.count}, 1) = 1 ;;
  }
  assert: fifth_user_full_name_matches {
    expression: index(${users.id}, 5) = 5 AND index(${users.full_name}, 5) = "Nicholas Turner" AND sum(${users.count}) = 5 ;;
  }
}

test: users_email_persona_and_us_state_2024_01_01 {
  explore_source: users {
    column: email_handle_persona { field: users.email_handle_persona }
    column: count { field: users.count }
    column: us_registered_users { field: users.us_registered_users }
    filters: [users.created_date: "2024-01-01"]
    sorts: [users.email_handle_persona: asc]
  }
  assert: short_alphabetic_handle_slice_matches {
    expression: index(${users.email_handle_persona}, 1) = "Short Clean Alphabetic Handle (<16 Letters, No Digits)"
      AND index(${users.count}, 1) = 36
      AND index(${users.us_registered_users}, 1) = 8 ;;
  }
  assert: long_aristocratic_handle_slice_matches {
    expression: index(${users.email_handle_persona}, 2) = "Long Aristocratic Handle (16+ Letters, No Digits)"
      AND index(${users.count}, 2) = 2
      AND index(${users.us_registered_users}, 2) = 1 ;;
  }
}

test: users_2024_01_01_geographic_reach_metrics {
  explore_source: users {
    column: distinct_states { field: users.distinct_states }
    column: distinct_cities { field: users.distinct_cities }
    column: distinct_postal_codes { field: users.distinct_postal_codes }
    column: avg_resident_age { field: users.avg_resident_age }
    column: count { field: users.count }
    filters: {
      field: users.created_date
      value: "2024-01-01"
    }
  }
  assert: distinct_states_matches {
    expression: ${users.distinct_states} = 32 ;;
  }
  assert: distinct_cities_matches {
    expression: ${users.distinct_cities} = 37 ;;
  }
  assert: distinct_postal_codes_matches {
    expression: ${users.distinct_postal_codes} = 38 ;;
  }
  assert: user_count_matches {
    expression: ${users.count} = 38 ;;
  }
  assert: avg_resident_age_min_bound {
    expression: ${users.avg_resident_age} >= 12 ;;
  }
  assert: avg_resident_age_max_bound {
    expression: ${users.avg_resident_age} <= 90 ;;
  }
}

test: users_2024_01_01_vanity_and_life_stage_dims {
  explore_source: users {
    column: life_stage_zone { field: users.life_stage_zone }
    column: first_initial { field: users.first_initial }
    column: full_name_letter_count { field: users.full_name_letter_count }
    column: count { field: users.count }
    filters: [users.created_date: "2024-01-01"]
    sorts: [
      users.life_stage_zone: asc,
      users.first_initial: asc,
      users.full_name_letter_count: asc
    ]
  }
  assert: first_row_youth_vanity_matches {
    expression: index(${users.life_stage_zone}, 1) = "Youth Budget (<25)" AND index(${users.first_initial}, 1) = "A" AND index(${users.full_name_letter_count}, 1) = 10 AND index(${users.count}, 1) = 1 ;;
  }
  assert: career_builder_row_matches {
    expression: index(${users.life_stage_zone}, 8) = "Career Builder (25-39)" AND index(${users.first_initial}, 8) = "J" AND index(${users.full_name_letter_count}, 8) = 12 ;;
  }
}
