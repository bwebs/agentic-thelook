{
  "agentic_thelook.category_brand_facts_monopoly_concentration_invariants": {
    "assert": {
      "concentration_bounds_and_ratio_valid": {
        "expression": "${category_brand_facts.count} >= 3 AND ${category_brand_facts.top_3_brands_revenue} > 0 AND ${category_brand_facts.top_3_brands_revenue} <= ${category_brand_facts.total_category_revenue} AND round(${category_brand_facts.top_3_monopoly_share}, 6) = round(${category_brand_facts.top_3_brands_revenue} / ${category_brand_facts.total_category_revenue}, 6) AND NOT is_null(${category_brand_facts.oligopoly_ruling_brands})"
      }
    },
    "explore_source": {
      "category_brand_facts": {
        "column": {
          "category": {
            "field": "category_brand_facts.category"
          },
          "count": {
            "field": "category_brand_facts.count"
          },
          "oligopoly_ruling_brands": {
            "field": "category_brand_facts.oligopoly_ruling_brands"
          },
          "top_3_brands_revenue": {
            "field": "category_brand_facts.top_3_brands_revenue"
          },
          "top_3_monopoly_share": {
            "field": "category_brand_facts.top_3_monopoly_share"
          },
          "total_category_revenue": {
            "field": "category_brand_facts.total_category_revenue"
          }
        },
        "derived_column": null,
        "explore": "category_brand_facts",
        "expression_custom_filter": null,
        "filters": {
          "category_brand_facts.category": "Jeans,Sweaters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/category_brand_facts.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "category_brand_facts_monopoly_concentration_invariants"
  },
  "agentic_thelook.category_growth_share_portfolio_invariants": {
    "assert": {
      "quadrant_counts_and_skus_positive": {
        "expression": "NOT is_null(${category_growth_share_facts.bcg_growth_share_quadrant}) AND ${category_growth_share_facts.count} > 0 AND ${category_growth_share_facts.total_active_skus} >= ${category_growth_share_facts.count}"
      },
      "quadrant_financials_and_flagships_bounded": {
        "expression": "${category_growth_share_facts.total_quadrant_revenue} > ${category_growth_share_facts.total_quadrant_profit} AND ${category_growth_share_facts.total_quadrant_profit} > 0 AND ${category_growth_share_facts.avg_category_margin_rate} > 0 AND ${category_growth_share_facts.avg_category_margin_rate} < 1 AND length(${category_growth_share_facts.flagship_categories}) > 0"
      }
    },
    "explore_source": {
      "category_growth_share_facts": {
        "column": {
          "avg_category_margin_rate": {
            "field": "category_growth_share_facts.avg_category_margin_rate"
          },
          "bcg_growth_share_quadrant": {
            "field": "category_growth_share_facts.bcg_growth_share_quadrant"
          },
          "count": {
            "field": "category_growth_share_facts.count"
          },
          "flagship_categories": {
            "field": "category_growth_share_facts.flagship_categories"
          },
          "total_active_skus": {
            "field": "category_growth_share_facts.total_active_skus"
          },
          "total_quadrant_profit": {
            "field": "category_growth_share_facts.total_quadrant_profit"
          },
          "total_quadrant_revenue": {
            "field": "category_growth_share_facts.total_quadrant_revenue"
          }
        },
        "derived_column": null,
        "explore": "category_growth_share_facts",
        "expression_custom_filter": null,
        "filters": {
          "category_growth_share_facts.department": "Men,Women"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/category_growth_share_facts.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "category_growth_share_portfolio_invariants"
  },
  "agentic_thelook.distribution_centers_id_1_flagship_specialty_invariants": {
    "assert": {
      "flagship_specialty_invariants_hold": {
        "expression": "${warehouse_category_facts.count} >= 1 AND ${warehouse_category_facts.total_sold_units} > 0 AND ${warehouse_category_facts.total_category_revenue} > 0 AND NOT is_null(${warehouse_category_facts.top_signature_categories})"
      }
    },
    "explore_source": {
      "distribution_centers": {
        "column": {
          "categories_in_tier": {
            "field": "warehouse_category_facts.count"
          },
          "top_signature_categories": {
            "field": "warehouse_category_facts.top_signature_categories"
          },
          "total_category_revenue": {
            "field": "warehouse_category_facts.total_category_revenue"
          },
          "total_sold_units": {
            "field": "warehouse_category_facts.total_sold_units"
          }
        },
        "derived_column": null,
        "explore": "distribution_centers",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "1",
          "warehouse_category_facts.warehouse_specialty_tier": "Flagship Signature Crown Category (#1)"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/distribution_centers.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "distribution_centers_id_1_flagship_specialty_invariants"
  },
  "agentic_thelook.distribution_centers_id_le_10_logistics_belt": {
    "assert": {
      "logistics_belt_counts_match": {
        "expression": "index(${distribution_centers.logistics_belt}, 1) = \"East Coast Atlantic Port\" AND index(${distribution_centers.count}, 1) = 2 AND index(${distribution_centers.logistics_belt}, 2) = \"Midwest Heartland Freight Titan\" AND index(${distribution_centers.count}, 2) = 2 AND index(${distribution_centers.logistics_belt}, 3) = \"Pacific West Coast Gateway\" AND index(${distribution_centers.count}, 3) = 1 AND index(${distribution_centers.logistics_belt}, 4) = \"Southern Gulf & Sunbelt Hub\" AND index(${distribution_centers.count}, 4) = 5"
      }
    },
    "explore_source": {
      "distribution_centers": {
        "column": {
          "count": {
            "field": "distribution_centers.count"
          },
          "logistics_belt": {
            "field": "distribution_centers.logistics_belt"
          }
        },
        "derived_column": null,
        "explore": "distribution_centers",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "<=10"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/distribution_centers.test.lkml",
    "line": 20,
    "model": "agentic_thelook",
    "name": "distribution_centers_id_le_10_logistics_belt"
  },
  "agentic_thelook.distribution_centers_refinement_metrics": {
    "assert": {
      "mean_warehouse_latitude_matches": {
        "expression": "round(${distribution_centers.mean_warehouse_latitude}, 4) = 35.1174"
      },
      "total_warehouses_matches": {
        "expression": "${distribution_centers.count} = 1"
      }
    },
    "explore_source": {
      "distribution_centers": {
        "column": {
          "mean_warehouse_latitude": {
            "field": "distribution_centers.mean_warehouse_latitude"
          },
          "total_warehouses": {
            "field": "distribution_centers.count"
          }
        },
        "derived_column": null,
        "explore": "distribution_centers",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "1",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/distribution_centers.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "distribution_centers_refinement_metrics"
  },
  "agentic_thelook.event_transition_matrix_probability_invariants": {
    "assert": {
      "dwell_seconds_non_negative": {
        "expression": "${event_transition_matrix_facts.avg_seconds_before_transition} >= 0"
      },
      "transition_probability_matches_ratio": {
        "expression": "${event_transition_matrix_facts.transition_probability} > 0 AND ${event_transition_matrix_facts.transition_probability} <= 1 AND round(${event_transition_matrix_facts.transition_probability}, 6) = round(${event_transition_matrix_facts.transition_count} / ${event_transition_matrix_facts.total_departures_from_state}, 6)"
      }
    },
    "explore_source": {
      "event_transition_matrix_facts": {
        "column": {
          "avg_seconds_before_transition": {
            "field": "event_transition_matrix_facts.avg_seconds_before_transition"
          },
          "from_state": {
            "field": "event_transition_matrix_facts.from_state"
          },
          "to_state": {
            "field": "event_transition_matrix_facts.to_state"
          },
          "total_departures_from_state": {
            "field": "event_transition_matrix_facts.total_departures_from_state"
          },
          "transition_count": {
            "field": "event_transition_matrix_facts.transition_count"
          },
          "transition_probability": {
            "field": "event_transition_matrix_facts.transition_probability"
          }
        },
        "derived_column": null,
        "explore": "event_transition_matrix_facts",
        "expression_custom_filter": null,
        "filters": {
          "event_transition_matrix_facts.from_state": "cart"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/event_transition_matrix_facts.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "event_transition_matrix_probability_invariants"
  },
  "agentic_thelook.events_2024_01_01_away_from_home_events": {
    "assert": {
      "away_from_home_events_matches": {
        "expression": "${events_users_fields.away_from_home_events} = 0"
      },
      "signed_in_events_matches": {
        "expression": "${events.count} = 405"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "away_from_home_events": {
            "field": "events_users_fields.away_from_home_events"
          },
          "count": {
            "field": "events.count"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "users.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/events.test.lkml",
    "line": 111,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_away_from_home_events"
  },
  "agentic_thelook.events_2024_01_01_browser_persona": {
    "assert": {
      "browser_persona_counts_match": {
        "expression": "index(${events.browser_persona}, 1) = \"Google Chrome RAM Eater\" AND index(${events.count}, 1) = 428 AND index(${events.browser_persona}, 2) = \"Apple Walled-Garden Safari Snob\" AND index(${events.count}, 2) = 193 AND index(${events.browser_persona}, 3) = \"Open-Source Firefox Privacy Nerd\" AND index(${events.count}, 3) = 187 AND index(${events.browser_persona}, 4) = \"Time-Traveler Internet Explorer Dinosaur\" AND index(${events.count}, 4) = 22 AND index(${events.browser_persona}, 5) = \"Mystery Smart-Fridge / Other Browser\" AND index(${events.count}, 5) = 50"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "browser_persona": {
            "field": "events.browser_persona"
          },
          "count": {
            "field": "events.count"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 141,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_browser_persona"
  },
  "agentic_thelook.events_2024_01_01_deep_link_metrics": {
    "assert": {
      "approx_unique_sessions_matches": {
        "expression": "${events.approx_unique_sessions} = 267"
      },
      "avg_url_path_depth_matches": {
        "expression": "round(${events.avg_url_path_depth}, 2) = 2.6"
      },
      "brand_url_events_matches": {
        "expression": "${events.brand_url_events} = 232"
      },
      "category_url_events_matches": {
        "expression": "${events.category_url_events} = 232"
      },
      "department_url_events_matches": {
        "expression": "${events.department_url_events} = 232"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "approx_unique_sessions": {
            "field": "events.approx_unique_sessions"
          },
          "avg_url_path_depth": {
            "field": "events.avg_url_path_depth"
          },
          "brand_url_events": {
            "field": "events.brand_url_events"
          },
          "category_url_events": {
            "field": "events.category_url_events"
          },
          "department_url_events": {
            "field": "events.department_url_events"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 87,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_deep_link_metrics"
  },
  "agentic_thelook.events_2024_01_01_funnel_archetype_invariants": {
    "assert": {
      "funnel_session_invariants_hold": {
        "expression": "${browsing_session_facts.silent_cart_abandon_sessions} > 0 AND ${browsing_session_facts.explicit_cancel_sessions} > 0 AND ${browsing_session_facts.count} >= ${browsing_session_facts.converted_sessions} + ${browsing_session_facts.silent_cart_abandon_sessions} AND ${browsing_session_facts.avg_events_per_session} >= 1"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "avg_events_per_session": {
            "field": "browsing_session_facts.avg_events_per_session"
          },
          "converted_sessions": {
            "field": "browsing_session_facts.converted_sessions"
          },
          "explicit_cancel_sessions": {
            "field": "browsing_session_facts.explicit_cancel_sessions"
          },
          "silent_cart_abandon_sessions": {
            "field": "browsing_session_facts.silent_cart_abandon_sessions"
          },
          "total_sessions": {
            "field": "browsing_session_facts.count"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/events.test.lkml",
    "line": 71,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_funnel_archetype_invariants"
  },
  "agentic_thelook.events_2024_01_01_funnel_page_events": {
    "assert": {
      "department_events_matches": {
        "expression": "${events.department_events} = 223"
      },
      "home_events_matches": {
        "expression": "${events.home_events} = 30"
      },
      "product_events_matches": {
        "expression": "${events.product_events} = 308"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "department_events": {
            "field": "events.department_events"
          },
          "home_events": {
            "field": "events.home_events"
          },
          "product_events": {
            "field": "events.product_events"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 186,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_funnel_page_events"
  },
  "agentic_thelook.events_2024_01_01_latest_browser_metrics": {
    "assert": {
      "latest_browser_and_count_match": {
        "expression": "${events.latest_browser} = \"Chrome\" AND ${events.count} = 880"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "count": {
            "field": "events.count"
          },
          "latest_browser": {
            "field": "events.latest_browser"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 218,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_latest_browser_metrics"
  },
  "agentic_thelook.events_2024_01_01_marathon_tier_metrics": {
    "assert": {
      "audit_and_marathon_tiers_match": {
        "expression": "index(${browsing_session_facts.session_marathon_tier}, 3) = \"Serious Closet Audit (5-9 Events)\" AND index(${browsing_session_facts.count}, 3) = 71 AND index(${browsing_session_facts.converted_sessions}, 3) = 71 AND round(index(${browsing_session_facts.session_conversion_rate}, 3), 4) = 1 AND index(${browsing_session_facts.session_marathon_tier}, 4) = \"Doom-Scroll Fashion Marathon (10+ Events)\" AND index(${browsing_session_facts.count}, 4) = 23 AND index(${browsing_session_facts.converted_sessions}, 4) = 23 AND round(index(${browsing_session_facts.session_conversion_rate}, 4), 4) = 1"
      },
      "bounce_and_peek_tiers_match": {
        "expression": "index(${browsing_session_facts.session_marathon_tier}, 1) = \"One-Hit Bounce (1 Event)\" AND index(${browsing_session_facts.count}, 1) = 46 AND index(${browsing_session_facts.converted_sessions}, 1) = 0 AND round(index(${browsing_session_facts.session_conversion_rate}, 1), 4) = 0 AND index(${browsing_session_facts.session_marathon_tier}, 2) = \"Casual Window Peek (2-4 Events)\" AND index(${browsing_session_facts.count}, 2) = 129"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "converted_sessions": {
            "field": "browsing_session_facts.converted_sessions"
          },
          "session_conversion_rate": {
            "field": "browsing_session_facts.session_conversion_rate"
          },
          "session_marathon_tier": {
            "field": "browsing_session_facts.session_marathon_tier"
          },
          "sessions_count": {
            "field": "browsing_session_facts.count"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/events.test.lkml",
    "line": 51,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_marathon_tier_metrics"
  },
  "agentic_thelook.events_2024_01_01_max_sequence_metrics": {
    "assert": {
      "max_sequence_number_matches": {
        "expression": "${events.max_sequence_number} = 13"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "max_sequence_number": {
            "field": "events.max_sequence_number"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 74,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_max_sequence_metrics"
  },
  "agentic_thelook.events_2024_01_01_nomad_and_browser_metrics": {
    "assert": {
      "browser_combo_matches": {
        "expression": "${events.browser_combo} = \"Chrome + Firefox + IE + Other + Safari\""
      },
      "distinct_browsers_matches": {
        "expression": "${events.distinct_browsers} = 5"
      },
      "distinct_cities_matches": {
        "expression": "${events.distinct_cities} = 203"
      },
      "distinct_ip_addresses_matches": {
        "expression": "${events.distinct_ip_addresses} = 256"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "browser_combo": {
            "field": "events.browser_combo"
          },
          "distinct_browsers": {
            "field": "events.distinct_browsers"
          },
          "distinct_cities": {
            "field": "events.distinct_cities"
          },
          "distinct_ip_addresses": {
            "field": "events.distinct_ip_addresses"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 230,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_nomad_and_browser_metrics"
  },
  "agentic_thelook.events_2024_01_01_session_purchase_metrics": {
    "assert": {
      "click_journey_path_populated": {
        "expression": "length(${events.click_journey_path}) > 0"
      },
      "purchasing_sessions_matches": {
        "expression": "${events.purchasing_sessions} = 63"
      },
      "session_purchase_rate_matches": {
        "expression": "round(${events.session_purchase_rate}, 4) = 0.2461"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "click_journey_path": {
            "field": "events.click_journey_path"
          },
          "purchasing_sessions": {
            "field": "events.purchasing_sessions"
          },
          "session_purchase_rate": {
            "field": "events.session_purchase_rate"
          },
          "unique_chaotic_sessions": {
            "field": "events.unique_chaotic_sessions"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 252,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_session_purchase_metrics"
  },
  "agentic_thelook.events_2024_01_01_session_span_and_click_trail_metrics": {
    "assert": {
      "first_session_span_and_trail_matches": {
        "expression": "index(${events.session_id}, 1) = \"00a05f63-5d71-49ee-bccf-7f0103c94dc0\" AND index(${events.count}, 1) = 6 AND index(${events.event_span_minutes}, 1) = 10 AND index(${events.click_trail}, 1) = \"department>product>cart>department>product>cart\""
      },
      "second_session_converting_trail_matches": {
        "expression": "index(${events.session_id}, 2) = \"0419867a-8983-474c-8982-c19c5ed7b378\" AND index(${events.count}, 2) = 5 AND index(${events.event_span_minutes}, 2) = 7 AND index(${events.click_trail}, 2) = \"home>department>product>cart>purchase\""
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "click_trail": {
            "field": "events.click_trail"
          },
          "count": {
            "field": "events.count"
          },
          "event_span_minutes": {
            "field": "events.event_span_minutes"
          },
          "session_id": {
            "field": "events.session_id"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.count": ">=5",
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 162,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_session_span_and_click_trail_metrics"
  },
  "agentic_thelook.events_2024_01_01_session_structural_role": {
    "assert": {
      "session_structural_role_counts_match": {
        "expression": "index(${event_session_steps.session_structural_role}, 1) = \"Solo Single-Click Bounce Event\" AND index(${events.count}, 1) = 46 AND index(${event_session_steps.session_structural_role}, 2) = \"Doorway Opener (Session First Touch)\" AND index(${events.count}, 2) = 202 AND index(${event_session_steps.session_structural_role}, 3) = \"Middle-Funnel Meandering Step\" AND index(${events.count}, 3) = 449 AND index(${event_session_steps.session_structural_role}, 4) = \"Curtain Closer (Session Last Touch)\" AND index(${events.count}, 4) = 183"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "count": {
            "field": "events.count"
          },
          "session_structural_role": {
            "field": "event_session_steps.session_structural_role"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/events.test.lkml",
    "line": 32,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_session_structural_role"
  },
  "agentic_thelook.events_2024_01_01_speed_runner_checkout_metrics": {
    "assert": {
      "avg_checkout_duration_sec_matches": {
        "expression": "round(${event_session_facts.avg_checkout_duration_sec}, 2) = 123270.09"
      },
      "max_checkout_duration_sec_matches": {
        "expression": "${event_session_facts.max_checkout_duration_sec} = 346922"
      },
      "min_checkout_duration_sec_matches": {
        "expression": "${event_session_facts.min_checkout_duration_sec} = 35"
      },
      "purchasing_sessions_matches": {
        "expression": "${event_session_facts.count} = 105"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "avg_checkout_duration_sec": {
            "field": "event_session_facts.avg_checkout_duration_sec"
          },
          "max_checkout_duration_sec": {
            "field": "event_session_facts.max_checkout_duration_sec"
          },
          "min_checkout_duration_sec": {
            "field": "event_session_facts.min_checkout_duration_sec"
          },
          "purchasing_sessions": {
            "field": "event_session_facts.count"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "event_session_facts.session_id": "-NULL",
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/events.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_speed_runner_checkout_metrics"
  },
  "agentic_thelook.events_2024_01_01_step_transition_metrics": {
    "assert": {
      "cancel_step_dwell_matches": {
        "expression": "index(${event_step_transitions.to_state}, 2) = \"cancel\" AND index(${events.count}, 2) = 41 AND round(index(${event_step_transitions.avg_seconds_before_transition}, 2), 1) = 1112.2"
      },
      "session_exit_zero_dwell_matches": {
        "expression": "index(${event_step_transitions.to_state}, 1) = \"SESSION_EXIT\" AND index(${events.count}, 1) = 239 AND index(${event_step_transitions.avg_seconds_before_transition}, 1) = 0"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "avg_seconds_before_transition": {
            "field": "event_step_transitions.avg_seconds_before_transition"
          },
          "count": {
            "field": "events.count"
          },
          "to_state": {
            "field": "event_step_transitions.to_state"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/events.test.lkml",
    "line": 128,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_step_transition_metrics"
  },
  "agentic_thelook.events_2024_01_01_uri_segment_metrics": {
    "assert": {
      "approx_unique_sessions_matches": {
        "expression": "${events.approx_unique_sessions} = 152"
      },
      "count_matches": {
        "expression": "${events.count} = 232"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "approx_unique_sessions": {
            "field": "events.approx_unique_sessions"
          },
          "count": {
            "field": "events.count"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "events__uri_segments.uri_segment": "department",
          "events__uri_segments.url_directory_depth_level": "<=2",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 116,
    "model": "agentic_thelook",
    "name": "events_2024_01_01_uri_segment_metrics"
  },
  "agentic_thelook.events_distinct_traffic_sources_2024_01_01": {
    "assert": {
      "distinct_traffic_sources_matches": {
        "expression": "${events.distinct_traffic_sources} = 5"
      },
      "event_count_matches": {
        "expression": "${events.count} = 880"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "count": {
            "field": "events.count"
          },
          "distinct_traffic_sources": {
            "field": "events.distinct_traffic_sources"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 204,
    "model": "agentic_thelook",
    "name": "events_distinct_traffic_sources_2024_01_01"
  },
  "agentic_thelook.events_ie_dinosaur_2024_01_01_metrics": {
    "assert": {
      "count_matches": {
        "expression": "${events.count} = 922"
      },
      "ie_event_share_matches": {
        "expression": "round(${events.ie_event_share}, 4) = 0.0813"
      },
      "ie_events_matches": {
        "expression": "${events.ie_events} = 75"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "count": {
            "field": "events.count"
          },
          "ie_event_share": {
            "field": "events.ie_event_share"
          },
          "ie_events": {
            "field": "events.ie_events"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 53,
    "model": "agentic_thelook",
    "name": "events_ie_dinosaur_2024_01_01_metrics"
  },
  "agentic_thelook.events_loop_archetype_and_crossover_2024_01": {
    "assert": {
      "linear_forward_march_slice_matches": {
        "expression": "index(${browsing_session_facts.clickstream_loop_archetype}, 1) = \"Linear Forward March (3+ Steps, 0 Backtracks)\" AND index(${browsing_session_facts.count}, 1) = 4741 AND index(${event_step_triplets.pogo_stick_oscillations}, 1) = 0 AND index(${events_users_fields.channel_crossover_events}, 1) = 13700"
      },
      "short_micro_session_slice_matches": {
        "expression": "index(${browsing_session_facts.clickstream_loop_archetype}, 2) = \"Short Micro-Session (<3 Steps)\" AND index(${browsing_session_facts.count}, 2) = 2677 AND index(${event_step_triplets.pogo_stick_oscillations}, 2) = 0 AND index(${events_users_fields.channel_crossover_events}, 2) = 0"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "channel_crossover_events": {
            "field": "events_users_fields.channel_crossover_events"
          },
          "clickstream_loop_archetype": {
            "field": "browsing_session_facts.clickstream_loop_archetype"
          },
          "pogo_stick_oscillations": {
            "field": "event_step_triplets.pogo_stick_oscillations"
          },
          "sessions_count": {
            "field": "browsing_session_facts.count"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/events.test.lkml",
    "line": 88,
    "model": "agentic_thelook",
    "name": "events_loop_archetype_and_crossover_2024_01"
  },
  "agentic_thelook.events_rage_quit_abandonment_metrics": {
    "assert": {
      "cancel_events_matches": {
        "expression": "${events.cancel_events} = 44"
      },
      "cancel_to_cart_ratio_matches": {
        "expression": "round(${events.cancel_to_cart_ratio}, 4) = 0.2304"
      },
      "cart_events_matches": {
        "expression": "${events.cart_events} = 191"
      },
      "carts_per_purchase_ratio_matches": {
        "expression": "round(${events.carts_per_purchase_ratio}, 2) = 3.03"
      },
      "purchase_events_matches": {
        "expression": "${events.purchase_events} = 63"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "cancel_events": {
            "field": "events.cancel_events"
          },
          "cancel_to_cart_ratio": {
            "field": "events.cancel_to_cart_ratio"
          },
          "cart_events": {
            "field": "events.cart_events"
          },
          "carts_per_purchase_ratio": {
            "field": "events.carts_per_purchase_ratio"
          },
          "purchase_events": {
            "field": "events.purchase_events"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 24,
    "model": "agentic_thelook",
    "name": "events_rage_quit_abandonment_metrics"
  },
  "agentic_thelook.events_refinement_metrics": {
    "assert": {
      "count_matches": {
        "expression": "${events.count} = 774"
      },
      "distinct_clicking_humans_matches": {
        "expression": "${events.distinct_clicking_humans} = 63"
      },
      "unique_chaotic_sessions_matches": {
        "expression": "${events.unique_chaotic_sessions} = 251"
      }
    },
    "explore_source": {
      "events": {
        "column": {
          "count": {
            "field": "events.count"
          },
          "distinct_clicking_humans": {
            "field": "events.distinct_clicking_humans"
          },
          "unique_chaotic_sessions": {
            "field": "events.unique_chaotic_sessions"
          }
        },
        "derived_column": null,
        "explore": "events",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "events_refinement_metrics"
  },
  "agentic_thelook.inventory_items_2024_01_01_products_join_metrics": {
    "assert": {
      "distinct_categories_matches": {
        "expression": "${products.distinct_categories} = 25"
      },
      "intake_unit_count_matches": {
        "expression": "${inventory_items.count} = 186"
      },
      "sold_plus_unsold_equals_total_units": {
        "expression": "${inventory_items.sold_units} + ${inventory_items.unsold_units} = ${inventory_items.count}"
      }
    },
    "explore_source": {
      "inventory_items": {
        "column": {
          "count": {
            "field": "inventory_items.count"
          },
          "distinct_categories": {
            "field": "products.distinct_categories"
          },
          "sold_units": {
            "field": "inventory_items.sold_units"
          },
          "unsold_units": {
            "field": "inventory_items.unsold_units"
          }
        },
        "derived_column": null,
        "explore": "inventory_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.created_date": "2024-01-01",
          "products.id": "NOT NULL",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/inventory_items.test.lkml",
    "line": 32,
    "model": "agentic_thelook",
    "name": "inventory_items_2024_01_01_products_join_metrics"
  },
  "agentic_thelook.inventory_items_2024_01_01_turnover_metrics": {
    "assert": {
      "avg_days_on_shelf_matches": {
        "expression": "round(${inventory_items.avg_days_on_shelf}, 2) = 29.95"
      },
      "sell_through_rate_matches": {
        "expression": "round(${inventory_items.sell_through_rate}, 4) = 1"
      },
      "sold_units_matches": {
        "expression": "${inventory_items.sold_units} = 80"
      },
      "total_cost_matches": {
        "expression": "round(${inventory_items.total_cost}, 2) = 2152.29"
      },
      "unsold_units_matches": {
        "expression": "${inventory_items.unsold_units} = 0"
      }
    },
    "explore_source": {
      "inventory_items": {
        "column": {
          "avg_days_on_shelf": {
            "field": "inventory_items.avg_days_on_shelf"
          },
          "sell_through_rate": {
            "field": "inventory_items.sell_through_rate"
          },
          "sold_units": {
            "field": "inventory_items.sold_units"
          },
          "total_cost": {
            "field": "inventory_items.total_cost"
          },
          "unsold_units": {
            "field": "inventory_items.unsold_units"
          }
        },
        "derived_column": null,
        "explore": "inventory_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.sold_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/inventory_items.test.lkml",
    "line": 24,
    "model": "agentic_thelook",
    "name": "inventory_items_2024_01_01_turnover_metrics"
  },
  "agentic_thelook.inventory_items_2024_01_01_unsold_shelf_sitter_invariants": {
    "assert": {
      "shelf_sitter_cost_matches_sunk_cost": {
        "expression": "coalesce(round(${inventory_items.total_cost}, 2), 0) = coalesce(round(${inventory_items.sunk_dusty_shelf_cost}, 2), 0) AND coalesce(${inventory_items.total_cost}, 0) >= 0"
      },
      "shelf_sitter_count_non_negative": {
        "expression": "${inventory_items.count} >= 0"
      },
      "unsold_units_match_shelf_sitter_count": {
        "expression": "${inventory_items.unsold_units} = ${inventory_items.count}"
      },
      "zero_sold_units_in_shelf_sitter_slice": {
        "expression": "${inventory_items.sold_units} = 0"
      }
    },
    "explore_source": {
      "inventory_items": {
        "column": {
          "count": {
            "field": "inventory_items.count"
          },
          "sold_units": {
            "field": "inventory_items.sold_units"
          },
          "sunk_dusty_shelf_cost": {
            "field": "inventory_items.sunk_dusty_shelf_cost"
          },
          "total_cost": {
            "field": "inventory_items.total_cost"
          },
          "unsold_units": {
            "field": "inventory_items.unsold_units"
          }
        },
        "derived_column": null,
        "explore": "inventory_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.created_date": "2024-01-01",
          "inventory_items.is_sold": "no",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/inventory_items.test.lkml",
    "line": 53,
    "model": "agentic_thelook",
    "name": "inventory_items_2024_01_01_unsold_shelf_sitter_invariants"
  },
  "agentic_thelook.inventory_items_2024_01_01_warehouse_turnover_metrics": {
    "assert": {
      "avg_days_on_shelf_matches": {
        "expression": "round(${inventory_items.avg_days_on_shelf}, 2) = 26.6"
      },
      "sold_units_matches": {
        "expression": "${inventory_items.sold_units} = 10"
      },
      "total_cost_matches": {
        "expression": "round(${inventory_items.total_cost}, 2) = 218.22"
      },
      "warehouse_name_matches": {
        "expression": "${distribution_centers.name} = \"Memphis TN\""
      }
    },
    "explore_source": {
      "inventory_items": {
        "column": {
          "avg_days_on_shelf": {
            "field": "inventory_items.avg_days_on_shelf"
          },
          "sold_units": {
            "field": "inventory_items.sold_units"
          },
          "total_cost": {
            "field": "inventory_items.total_cost"
          },
          "warehouse_name": {
            "field": "distribution_centers.name"
          }
        },
        "derived_column": null,
        "explore": "inventory_items",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.name": "Memphis TN",
          "inventory_items.sold_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/inventory_items.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "inventory_items_2024_01_01_warehouse_turnover_metrics"
  },
  "agentic_thelook.inventory_items_2024_01_fifo_anomaly_invariants": {
    "assert": {
      "fifo_violation_rate_bounds_and_identity": {
        "expression": "${inventory_items.sold_units} > 0 AND ${inventory_items_inventory_items_fifo_batches_fields.fifo_line_cutter_shipments} >= 0 AND ${inventory_items_inventory_items_fifo_batches_fields.fifo_line_cutter_shipments} <= ${inventory_items.sold_units} AND round(${inventory_items_inventory_items_fifo_batches_fields.fifo_violation_rate}, 6) = round(${inventory_items_inventory_items_fifo_batches_fields.fifo_line_cutter_shipments} / ${inventory_items.sold_units}, 6)"
      }
    },
    "explore_source": {
      "inventory_items": {
        "column": {
          "fifo_line_cutter_shipments": {
            "field": "inventory_items_inventory_items_fifo_batches_fields.fifo_line_cutter_shipments"
          },
          "fifo_violation_rate": {
            "field": "inventory_items_inventory_items_fifo_batches_fields.fifo_violation_rate"
          },
          "sold_units": {
            "field": "inventory_items.sold_units"
          }
        },
        "derived_column": null,
        "explore": "inventory_items",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "NOT NULL",
          "inventory_items.sold_date": "2024-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/inventory_items.test.lkml",
    "line": 58,
    "model": "agentic_thelook",
    "name": "inventory_items_2024_01_fifo_anomaly_invariants"
  },
  "agentic_thelook.inventory_items_refinement_metrics": {
    "assert": {
      "hypothetical_retail_value_matches": {
        "expression": "round(${inventory_items.hypothetical_retail_value}, 2) = 6389.09"
      },
      "inventory_item_count_matches": {
        "expression": "${inventory_items.count} = 188"
      },
      "sunk_dusty_shelf_cost_matches": {
        "expression": "round(${inventory_items.sunk_dusty_shelf_cost}, 2) = 3031.82"
      }
    },
    "explore_source": {
      "inventory_items": {
        "column": {
          "hypothetical_retail_value": {
            "field": "inventory_items.hypothetical_retail_value"
          },
          "inventory_item_count": {
            "field": "inventory_items.count"
          },
          "sunk_dusty_shelf_cost": {
            "field": "inventory_items.sunk_dusty_shelf_cost"
          }
        },
        "derived_column": null,
        "explore": "inventory_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/inventory_items.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "inventory_items_refinement_metrics"
  },
  "agentic_thelook.inventory_items_sold_2024_01_01_aging_tier_metrics": {
    "assert": {
      "sold_aging_tier_matches": {
        "expression": "${inventory_items.inventory_aging_tier} = \"Fresh Off the Truck (<90 Days)\""
      },
      "sold_units_and_cost_match": {
        "expression": "${inventory_items.sold_units} = 55 AND round(${inventory_items.total_cost}, 2) = 1413.30"
      }
    },
    "explore_source": {
      "inventory_items": {
        "column": {
          "inventory_aging_tier": {
            "field": "inventory_items.inventory_aging_tier"
          },
          "sold_units": {
            "field": "inventory_items.sold_units"
          },
          "total_cost": {
            "field": "inventory_items.total_cost"
          }
        },
        "derived_column": null,
        "explore": "inventory_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.is_sold": "yes",
          "inventory_items.sold_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/inventory_items.test.lkml",
    "line": 83,
    "model": "agentic_thelook",
    "name": "inventory_items_sold_2024_01_01_aging_tier_metrics"
  },
  "agentic_thelook.inventory_items_sold_2024_01_01_stddev_days_on_shelf": {
    "assert": {
      "sold_units_matches": {
        "expression": "${inventory_items.sold_units} = 63"
      },
      "stddev_days_on_shelf_matches": {
        "expression": "round(${inventory_items.stddev_days_on_shelf}, 2) = 17.01"
      }
    },
    "explore_source": {
      "inventory_items": {
        "column": {
          "avg_days_on_shelf": {
            "field": "inventory_items.avg_days_on_shelf"
          },
          "sold_units": {
            "field": "inventory_items.sold_units"
          },
          "stddev_days_on_shelf": {
            "field": "inventory_items.stddev_days_on_shelf"
          }
        },
        "derived_column": null,
        "explore": "inventory_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.is_sold": "yes",
          "inventory_items.sold_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/inventory_items.test.lkml",
    "line": 106,
    "model": "agentic_thelook",
    "name": "inventory_items_sold_2024_01_01_stddev_days_on_shelf"
  },
  "agentic_thelook.logistics_network_nodes_warehouse_hubs_by_belt": {
    "assert": {
      "warehouse_hub_belt_counts_match": {
        "expression": "index(${logistics_network_nodes.logistics_belt}, 1) = \"East Coast Atlantic Port\" AND index(${logistics_network_nodes.count}, 1) = 2 AND index(${logistics_network_nodes.logistics_belt}, 2) = \"Midwest Heartland Freight Titan\" AND index(${logistics_network_nodes.count}, 2) = 2 AND index(${logistics_network_nodes.logistics_belt}, 3) = \"Pacific West Coast Gateway\" AND index(${logistics_network_nodes.count}, 3) = 1 AND index(${logistics_network_nodes.logistics_belt}, 4) = \"Southern Gulf & Sunbelt Hub\" AND index(${logistics_network_nodes.count}, 4) = 5"
      }
    },
    "explore_source": {
      "logistics_network_nodes": {
        "column": {
          "count": {
            "field": "logistics_network_nodes.count"
          },
          "logistics_belt": {
            "field": "logistics_network_nodes.logistics_belt"
          }
        },
        "derived_column": null,
        "explore": "logistics_network_nodes",
        "expression_custom_filter": null,
        "filters": {
          "logistics_network_nodes.network_node_type": "Physical Warehouse Hub"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/logistics_network_nodes.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "logistics_network_nodes_warehouse_hubs_by_belt"
  },
  "agentic_thelook.monthly_revenue_facts_2024_01_momentum": {
    "assert": {
      "monthly_volume_and_revenue_match": {
        "expression": "${monthly_revenue_facts.orders_count} = 1436 AND ${monthly_revenue_facts.items_count} = 1975 AND round(${monthly_revenue_facts.monthly_revenue}, 2) = 119747.25"
      },
      "prior_month_and_whiplash_match": {
        "expression": "round(${monthly_revenue_facts.prev_month_revenue}, 2) = 121554.86 AND round(${monthly_revenue_facts.mom_revenue_growth_rate}, 4) = -0.0149"
      },
      "rolling_and_cumulative_revenue_match": {
        "expression": "round(${monthly_revenue_facts.rolling_3m_avg_revenue}, 2) = 117578.07 AND round(${monthly_revenue_facts.cumulative_all_time_revenue}, 2) = 2970882.55"
      }
    },
    "explore_source": {
      "monthly_revenue_facts": {
        "column": {
          "cumulative_all_time_revenue": {
            "field": "monthly_revenue_facts.cumulative_all_time_revenue"
          },
          "items_count": {
            "field": "monthly_revenue_facts.items_count"
          },
          "mom_revenue_growth_rate": {
            "field": "monthly_revenue_facts.mom_revenue_growth_rate"
          },
          "monthly_revenue": {
            "field": "monthly_revenue_facts.monthly_revenue"
          },
          "orders_count": {
            "field": "monthly_revenue_facts.orders_count"
          },
          "prev_month_revenue": {
            "field": "monthly_revenue_facts.prev_month_revenue"
          },
          "rolling_3m_avg_revenue": {
            "field": "monthly_revenue_facts.rolling_3m_avg_revenue"
          }
        },
        "derived_column": null,
        "explore": "monthly_revenue_facts",
        "expression_custom_filter": null,
        "filters": {
          "monthly_revenue_facts.created_month": "2024-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/monthly_revenue_facts.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "monthly_revenue_facts_2024_01_momentum"
  },
  "agentic_thelook.order_items_2024_01_01_active_buyers_metrics": {
    "assert": {
      "distinct_users_matches": {
        "expression": "${order_items.distinct_users} = 71"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "distinct_users": {
            "field": "order_items.distinct_users"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 91,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_active_buyers_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_boomerang_return_metrics": {
    "assert": {
      "ever_return_rate_matches": {
        "expression": "round(${order_items.ever_return_rate}, 4) = 0.15"
      },
      "ever_returned_items_matches": {
        "expression": "${order_items.ever_returned_items} = 12"
      },
      "refunded_revenue_matches": {
        "expression": "round(${order_items.refunded_revenue}, 2) = 563.41"
      },
      "return_rate_matches": {
        "expression": "round(${order_items.return_rate}, 4) = 0.15"
      },
      "returned_items_matches": {
        "expression": "${order_items.returned_items} = 12"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "ever_return_rate": {
            "field": "order_items.ever_return_rate"
          },
          "ever_returned_items": {
            "field": "order_items.ever_returned_items"
          },
          "refunded_revenue": {
            "field": "order_items.refunded_revenue"
          },
          "return_rate": {
            "field": "order_items.return_rate"
          },
          "returned_items": {
            "field": "order_items.returned_items"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 104,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_boomerang_return_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_cross_shopping_metrics": {
    "assert": {
      "avg_item_price_matches": {
        "expression": "round(${order_items.avg_item_price}, 2) = 57.06"
      },
      "cross_department_gift_items_matches": {
        "expression": "${order_items_products_users_fields.cross_department_gift_items} = 0"
      },
      "cross_shopping_rate_matches": {
        "expression": "round(${order_items_products_users_fields.cross_shopping_rate}, 4) = 0"
      },
      "order_item_count_matches": {
        "expression": "${order_items.count} = 80"
      },
      "total_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 4564.89"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_item_price": {
            "field": "order_items.avg_item_price"
          },
          "cross_department_gift_items": {
            "field": "order_items_products_users_fields.cross_department_gift_items"
          },
          "cross_shopping_rate": {
            "field": "order_items_products_users_fields.cross_shopping_rate"
          },
          "order_item_count": {
            "field": "order_items.count"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "orders.order_id": "NOT NULL",
          "products.id": "NOT NULL",
          "type_": "filters",
          "users.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 114,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_cross_shopping_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_dc_1_join_metrics": {
    "assert": {
      "dc_1_item_count_matches": {
        "expression": "${order_items.count} = 4"
      },
      "dc_1_total_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 194.97"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "item_count": {
            "field": "order_items.count"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "1",
          "order_items.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 185,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_dc_1_join_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_garment_mileage_and_category_baseline_metrics": {
    "assert": {
      "category_baseline_and_orders_positive": {
        "expression": "${category_sales_facts_order_items_fields.avg_category_baseline} > 0 AND ${category_sales_facts.category_orders} > 0"
      },
      "shipment_distance_totals_match": {
        "expression": "${order_items.count} = 63 AND round(${distribution_centers_order_items_users_fields.total_shipment_distance_km}, 2) = 500658.68 AND round(${distribution_centers_order_items_users_fields.earth_equator_laps_equivalent}, 2) = 12.49"
      },
      "shipment_efficiency_and_max_match": {
        "expression": "round(${distribution_centers_order_items_users_fields.revenue_per_1000_km_flown}, 4) = 5.7066 AND round(${distribution_centers_order_items_users_fields.max_shipment_distance_km}, 2) = 16702.00"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_category_baseline": {
            "field": "category_sales_facts_order_items_fields.avg_category_baseline"
          },
          "category_orders": {
            "field": "category_sales_facts.category_orders"
          },
          "earth_equator_laps_equivalent": {
            "field": "distribution_centers_order_items_users_fields.earth_equator_laps_equivalent"
          },
          "max_shipment_distance_km": {
            "field": "distribution_centers_order_items_users_fields.max_shipment_distance_km"
          },
          "revenue_per_1000_km_flown": {
            "field": "distribution_centers_order_items_users_fields.revenue_per_1000_km_flown"
          },
          "total_shipment_distance_km": {
            "field": "distribution_centers_order_items_users_fields.total_shipment_distance_km"
          },
          "tracked_shipments": {
            "field": "order_items.count"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "NOT NULL",
          "inventory_items.id": "NOT NULL",
          "order_items.created_date": "2024-01-01",
          "products.category": "-NULL",
          "products.id": "NOT NULL",
          "type_": "filters",
          "users.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 423,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_garment_mileage_and_category_baseline_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_geospatial_haul_metrics": {
    "assert": {
      "local_regional_hop_count_matches": {
        "expression": "index(${order_items.count}, 1) = 2"
      },
      "local_regional_hop_distance_matches": {
        "expression": "round(index(${distribution_centers_order_items_users_fields.avg_shipment_distance_km}, 1), 1) = 761.9"
      },
      "local_regional_hop_lat_span_matches": {
        "expression": "round(index(${distribution_centers_order_items_users_fields.avg_lat_degrees_crossed}, 1), 2) = 2.40"
      },
      "local_regional_hop_row_matches": {
        "expression": "index(${distribution_centers_order_items_users_fields.geospatial_haul_classification}, 1) = \"Local Regional Hop (<5 deg Lat & <10 deg Lon)\""
      },
      "trans_oceanic_expedition_count_matches": {
        "expression": "index(${order_items.count}, 3) = 45"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_lat_degrees_crossed": {
            "field": "distribution_centers_order_items_users_fields.avg_lat_degrees_crossed"
          },
          "avg_shipment_distance_km": {
            "field": "distribution_centers_order_items_users_fields.avg_shipment_distance_km"
          },
          "count": {
            "field": "order_items.count"
          },
          "geospatial_haul_classification": {
            "field": "distribution_centers_order_items_users_fields.geospatial_haul_classification"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "NOT NULL",
          "inventory_items.id": "NOT NULL",
          "order_items.created_date": "2024-01-01",
          "type_": "filters",
          "users.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 241,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_geospatial_haul_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_high_roller_single_item_metrics": {
    "assert": {
      "high_roller_avg_item_price_matches": {
        "expression": "round(${order_items.avg_item_price}, 2) = 199.62"
      },
      "high_roller_item_count_matches": {
        "expression": "${order_items.count} = 11"
      },
      "high_roller_total_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 2195.79"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_item_price": {
            "field": "order_items.avg_item_price"
          },
          "order_item_count": {
            "field": "order_items.count"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "order_items.is_high_roller_single_item": "yes",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 133,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_high_roller_single_item_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_orders_join_metrics": {
    "assert": {
      "ever_returned_items_matches": {
        "expression": "${order_items.ever_returned_items} = 12"
      },
      "order_count_symmetric_matches": {
        "expression": "${orders.count} = 71"
      },
      "order_item_count_matches": {
        "expression": "${order_items.count} = 80"
      },
      "refunded_revenue_matches": {
        "expression": "round(${order_items.refunded_revenue}, 2) = 563.41"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "ever_returned_items": {
            "field": "order_items.ever_returned_items"
          },
          "order_count": {
            "field": "orders.count"
          },
          "order_item_count": {
            "field": "order_items.count"
          },
          "refunded_revenue": {
            "field": "order_items.refunded_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "orders.order_id": "NOT NULL",
          "products.id": "NOT NULL",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 32,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_orders_join_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_sale_price_stddev_metrics": {
    "assert": {
      "order_item_count_matches": {
        "expression": "${order_items.count} = 63"
      },
      "stddev_sale_price_matches": {
        "expression": "round(${order_items.stddev_sale_price}, 2) = 29.67"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "order_item_count": {
            "field": "order_items.count"
          },
          "stddev_sale_price": {
            "field": "order_items.stddev_sale_price"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 262,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_sale_price_stddev_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_socks_obsession_metrics": {
    "assert": {
      "sock_revenue_share_matches": {
        "expression": "round(${order_items_products_fields.sock_revenue_share}, 4) = 0.0161"
      },
      "sock_unit_share_matches": {
        "expression": "round(${order_items_products_fields.sock_unit_share}, 4) = 0.075"
      },
      "sock_units_sold_matches": {
        "expression": "${order_items_products_fields.sock_units_sold} = 6"
      },
      "total_sock_revenue_matches": {
        "expression": "round(${order_items_products_fields.total_sock_revenue}, 2) = 73.39"
      },
      "total_units_sold_matches": {
        "expression": "${order_items.count} = 80"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "sock_revenue_share": {
            "field": "order_items_products_fields.sock_revenue_share"
          },
          "sock_unit_share": {
            "field": "order_items_products_fields.sock_unit_share"
          },
          "sock_units_sold": {
            "field": "order_items_products_fields.sock_units_sold"
          },
          "total_sock_revenue": {
            "field": "order_items_products_fields.total_sock_revenue"
          },
          "total_units_sold": {
            "field": "order_items.count"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_socks_obsession_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_spend_per_buyer": {
    "assert": {
      "spend_per_buyer_matches": {
        "expression": "round(${order_items.spend_per_buyer}, 2) = 70.20"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "distinct_users": {
            "field": "order_items.distinct_users"
          },
          "spend_per_buyer": {
            "field": "order_items.spend_per_buyer"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "order_items.status": "Complete"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 233,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_spend_per_buyer"
  },
  "agentic_thelook.order_items_2024_01_01_thermal_chill_metrics": {
    "assert": {
      "age_price_correlation_matches": {
        "expression": "round(${order_items_users_fields.age_price_correlation}, 4) = 0.1331"
      },
      "avg_abs_latitude_symmetric_matches": {
        "expression": "round(${users.avg_abs_latitude}, 2) = 32.92"
      },
      "avg_activity_weighted_abs_latitude_matches": {
        "expression": "round(${order_items_users_fields.avg_activity_weighted_abs_latitude}, 2) = 32.44"
      },
      "latitude_price_correlation_matches": {
        "expression": "round(${order_items_users_fields.latitude_price_correlation}, 4) = -0.1648"
      },
      "order_item_count_matches": {
        "expression": "${order_items.count} = 80"
      },
      "total_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 4564.89"
      },
      "total_warm_clothing_revenue_matches": {
        "expression": "round(${order_items_products_fields.total_warm_clothing_revenue}, 2) = 1060.61"
      },
      "warm_clothing_revenue_share_matches": {
        "expression": "round(${order_items_products_fields.warm_clothing_revenue_share}, 4) = 0.2323"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "age_price_correlation": {
            "field": "order_items_users_fields.age_price_correlation"
          },
          "avg_abs_latitude": {
            "field": "users.avg_abs_latitude"
          },
          "avg_activity_weighted_abs_latitude": {
            "field": "order_items_users_fields.avg_activity_weighted_abs_latitude"
          },
          "latitude_price_correlation": {
            "field": "order_items_users_fields.latitude_price_correlation"
          },
          "order_item_count": {
            "field": "order_items.count"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          },
          "total_warm_clothing_revenue": {
            "field": "order_items_products_fields.total_warm_clothing_revenue"
          },
          "warm_clothing_revenue_share": {
            "field": "order_items_products_fields.warm_clothing_revenue_share"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "products.id": "NOT NULL",
          "type_": "filters",
          "users.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 65,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_thermal_chill_metrics"
  },
  "agentic_thelook.order_items_2024_01_01_title_verbosity_correlations": {
    "assert": {
      "avg_price_per_title_word_matches": {
        "expression": "round(${order_items_products_fields.avg_price_per_title_word}, 2) = 9.84"
      },
      "title_char_length_price_correlation_matches": {
        "expression": "round(${order_items_products_fields.title_char_length_price_correlation}, 4) = 0.3988"
      },
      "title_word_count_price_correlation_matches": {
        "expression": "round(${order_items_products_fields.title_word_count_price_correlation}, 4) = 0.2068"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_price_per_title_word": {
            "field": "order_items_products_fields.avg_price_per_title_word"
          },
          "title_char_length_price_correlation": {
            "field": "order_items_products_fields.title_char_length_price_correlation"
          },
          "title_word_count_price_correlation": {
            "field": "order_items_products_fields.title_word_count_price_correlation"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "order_items.status": "Complete",
          "products.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 382,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_title_verbosity_correlations"
  },
  "agentic_thelook.order_items_2024_01_01_trade_corridor_metrics": {
    "assert": {
      "domestic_short_haul_count_matches": {
        "expression": "index(${order_items.count}, 1) = 2"
      },
      "domestic_short_haul_label_matches": {
        "expression": "index(${distribution_centers_order_items_users_fields.trade_corridor_regime}, 1) = \"Domestic Short-Haul Trucking Corridor (<800 km US)\""
      },
      "transpacific_corridor_count_matches": {
        "expression": "index(${order_items.count}, 4) = 22"
      },
      "transpacific_corridor_distance_matches": {
        "expression": "round(index(${distribution_centers_order_items_users_fields.avg_shipment_distance_km}, 4), 1) = 11894.4"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_shipment_distance_km": {
            "field": "distribution_centers_order_items_users_fields.avg_shipment_distance_km"
          },
          "count": {
            "field": "order_items.count"
          },
          "trade_corridor_regime": {
            "field": "distribution_centers_order_items_users_fields.trade_corridor_regime"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "NOT NULL",
          "inventory_items.id": "NOT NULL",
          "order_items.created_date": "2024-01-01",
          "type_": "filters",
          "users.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 282,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_01_trade_corridor_metrics"
  },
  "agentic_thelook.order_items_2024_01_boomeranged_refund_metrics": {
    "assert": {
      "ever_returned_items_matches": {
        "expression": "${order_items.ever_returned_items} = 187"
      },
      "ever_returned_revenue_matches": {
        "expression": "round(${order_items.ever_returned_revenue}, 2) = 11430.93"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "ever_returned_items": {
            "field": "order_items.ever_returned_items"
          },
          "ever_returned_revenue": {
            "field": "order_items.ever_returned_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 248,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_boomeranged_refund_metrics"
  },
  "agentic_thelook.order_items_2024_01_complete_gross_profit": {
    "assert": {
      "gross_margin_ratio_matches": {
        "expression": "round(${inventory_items_order_items_fields.gross_margin_ratio}, 4) = 0.5221"
      },
      "total_gross_profit_matches": {
        "expression": "round(${inventory_items_order_items_fields.total_gross_profit}, 2) = 16633.21"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "gross_margin_ratio": {
            "field": "inventory_items_order_items_fields.gross_margin_ratio"
          },
          "total_gross_profit": {
            "field": "inventory_items_order_items_fields.total_gross_profit"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01",
          "order_items.status": "Complete",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 202,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_complete_gross_profit"
  },
  "agentic_thelook.order_items_2024_01_fulfillment_speed_tier": {
    "assert": {
      "fulfillment_speed_tier_counts_match": {
        "expression": "index(${order_items.fulfillment_speed_tier}, 1) = \"Supersonic Drone Speed (<24h)\" AND index(${order_items.count}, 1) = 118 AND index(${order_items.fulfillment_speed_tier}, 2) = \"Prime-ish Express (24-72h)\" AND index(${order_items.count}, 2) = 189 AND index(${order_items.fulfillment_speed_tier}, 3) = \"Standard Pony Express (72-120h)\" AND index(${order_items.count}, 3) = 248 AND index(${order_items.fulfillment_speed_tier}, 4) = \"Lost-at-Sea Snail Mail (120h+)\" AND index(${order_items.count}, 4) = 146"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "count": {
            "field": "order_items.count"
          },
          "fulfillment_speed_tier": {
            "field": "order_items.fulfillment_speed_tier"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.delivered_date": "2024-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 158,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_fulfillment_speed_tier"
  },
  "agentic_thelook.order_items_2024_01_margin_and_luxury_metrics": {
    "assert": {
      "avg_gross_profit_matches": {
        "expression": "round(${inventory_items_order_items_fields.avg_gross_profit}, 2) = 31.41"
      },
      "luxury_spend_matches": {
        "expression": "round(${order_items_products_fields.total_luxury_150plus_revenue}, 2) = 37209.72 AND round(${order_items_products_fields.luxury_spend_share}, 4) = 0.3107"
      },
      "total_cogs_matches": {
        "expression": "round(${inventory_items_order_items_fields.total_cogs}, 2) = 57712.62"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_gross_profit": {
            "field": "inventory_items_order_items_fields.avg_gross_profit"
          },
          "luxury_spend_share": {
            "field": "order_items_products_fields.luxury_spend_share"
          },
          "total_cogs": {
            "field": "inventory_items_order_items_fields.total_cogs"
          },
          "total_luxury_150plus_revenue": {
            "field": "order_items_products_fields.total_luxury_150plus_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.id": "NOT NULL",
          "order_items.created_month": "2024-01",
          "products.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 359,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_margin_and_luxury_metrics"
  },
  "agentic_thelook.order_items_2024_01_nomad_and_browser_invariants": {
    "assert": {
      "nomad_buyer_spend_identity": {
        "expression": "NOT is_null(${user_click_facts.ip_nomad_tier}) AND ${order_items.distinct_users} >= 1 AND ${order_items.total_revenue} > 0 AND round(${order_items.spend_per_buyer}, 4) = round(${order_items.total_revenue} / ${order_items.distinct_users}, 4)"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "distinct_users": {
            "field": "order_items.distinct_users"
          },
          "ip_nomad_tier": {
            "field": "user_click_facts.ip_nomad_tier"
          },
          "spend_per_buyer": {
            "field": "order_items.spend_per_buyer"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01",
          "user_click_facts.user_id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 404,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_nomad_and_browser_invariants"
  },
  "agentic_thelook.order_items_2024_01_seasonal_category_metrics": {
    "assert": {
      "activewear_units_matches": {
        "expression": "${order_items_products_fields.activewear_units} = 107"
      },
      "swimwear_units_matches": {
        "expression": "${order_items_products_fields.swimwear_units} = 118"
      },
      "total_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 123613.15"
      },
      "winter_cozy_units_matches": {
        "expression": "${order_items_products_fields.winter_cozy_units} = 238"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "activewear_units": {
            "field": "order_items_products_fields.activewear_units"
          },
          "swimwear_units": {
            "field": "order_items_products_fields.swimwear_units"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          },
          "winter_cozy_units": {
            "field": "order_items_products_fields.winter_cozy_units"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01 to 2024-02-01",
          "products.id": "NOT NULL",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 156,
    "model": "agentic_thelook",
    "name": "order_items_2024_01_seasonal_category_metrics"
  },
  "agentic_thelook.order_items_2024_2025_boundary_era_and_reversed_metrics": {
    "assert": {
      "is_reversed_partition_matches": {
        "expression": "NOT index(${order_items.is_reversed}, 1) AND index(${order_items.is_reversed}, 2) AND index(${order_items.completed_items}, 1) = 45 AND index(${order_items.completed_items}, 2) = 0"
      },
      "recent_era_revenue_matches": {
        "expression": "round(index(${order_items.recent_era_revenue}, 1), 2) = 1183.18 AND round(index(${order_items.recent_era_revenue}, 2), 2) = 853.92"
      },
      "recent_era_revenue_share_matches": {
        "expression": "round(index(${order_items.recent_era_revenue_share}, 1), 4) = 0.389 AND round(index(${order_items.recent_era_revenue_share}, 2), 4) = 0.4279"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "completed_items": {
            "field": "order_items.completed_items"
          },
          "is_reversed": {
            "field": "order_items.is_reversed"
          },
          "recent_era_revenue": {
            "field": "order_items.recent_era_revenue"
          },
          "recent_era_revenue_share": {
            "field": "order_items.recent_era_revenue_share"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-12-31,2025-01-01",
          "order_items.status": "Complete,Returned,Cancelled"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 205,
    "model": "agentic_thelook",
    "name": "order_items_2024_2025_boundary_era_and_reversed_metrics"
  },
  "agentic_thelook.order_items_2024_seasonal_vintage_metrics": {
    "assert": {
      "fall_layering_vintage_matches": {
        "expression": "index(${order_items.retail_seasonal_vintage}, 2) = \"Back-to-School & Fall Layering (Aug-Oct)\" AND index(${order_items.created_month_num}, 2) = 9 AND index(${order_items.count}, 2) = 83"
      },
      "mid_summer_vintage_matches": {
        "expression": "index(${order_items.retail_seasonal_vintage}, 4) = \"Mid-Summer Fiesta (Jun-Jul)\" AND index(${order_items.created_month_num}, 4) = 6 AND index(${order_items.count}, 4) = 92"
      },
      "new_year_rush_vintage_matches": {
        "expression": "index(${order_items.retail_seasonal_vintage}, 5) = \"New-Year Resolution Rush (Jan-Feb)\" AND index(${order_items.created_month_num}, 5) = 1 AND index(${order_items.count}, 5) = 60"
      },
      "q4_holiday_vintage_matches": {
        "expression": "index(${order_items.retail_seasonal_vintage}, 1) = \"Q4 Cyber-Holiday Frenzy (Nov-Dec)\" AND index(${order_items.created_month_num}, 1) = 11 AND index(${order_items.count}, 1) = 88"
      },
      "spring_reboot_vintage_matches": {
        "expression": "index(${order_items.retail_seasonal_vintage}, 3) = \"Spring Wardrobe Reboot (Mar-May)\" AND index(${order_items.created_month_num}, 3) = 4 AND index(${order_items.count}, 3) = 66"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "count": {
            "field": "order_items.count"
          },
          "created_month_num": {
            "field": "order_items.created_month_num"
          },
          "retail_seasonal_vintage": {
            "field": "order_items.retail_seasonal_vintage"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-15, 2024-04-15, 2024-06-15, 2024-09-15, 2024-11-15",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 177,
    "model": "agentic_thelook",
    "name": "order_items_2024_seasonal_vintage_metrics"
  },
  "agentic_thelook.order_items_2024_w1_archetype_invariants": {
    "assert": {
      "archetype_exhaustive_and_reversal_zero_profit": {
        "expression": "NOT is_null(${category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.order_line_archetype}) AND ${order_items.count} > 0 AND ${order_items_user_click_facts_fields.avg_item_buyer_clicks} >= 0 AND if( contains(${category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.order_line_archetype}, \"Boomerang\"), coalesce(${inventory_items_order_items_fields.retained_net_profit}, 0) = 0, ${inventory_items_order_items_fields.retained_net_profit} > 0 )"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_item_buyer_clicks": {
            "field": "order_items_user_click_facts_fields.avg_item_buyer_clicks"
          },
          "count": {
            "field": "order_items.count"
          },
          "order_line_archetype": {
            "field": "category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.order_line_archetype"
          },
          "retained_net_profit": {
            "field": "inventory_items_order_items_fields.retained_net_profit"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.id": "NOT NULL",
          "order_items.created_date": "2024-01-01 to 2024-01-07",
          "order_items.status": "Complete,Returned,Cancelled"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 335,
    "model": "agentic_thelook",
    "name": "order_items_2024_w1_archetype_invariants"
  },
  "agentic_thelook.order_items_2024_w1_retained_profit_and_archetype_metrics": {
    "assert": {
      "retained_profit_and_shelf_age_match": {
        "expression": "round(${inventory_items_order_items_fields.retained_net_profit}, 2) = 3979.11 AND round(${inventory_items_order_items_fields.avg_order_shelf_age_days}, 1) = 0"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_order_shelf_age_days": {
            "field": "inventory_items_order_items_fields.avg_order_shelf_age_days"
          },
          "retained_net_profit": {
            "field": "inventory_items_order_items_fields.retained_net_profit"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.id": "NOT NULL",
          "order_items.created_date": "2024-01-01 to 2024-01-07",
          "order_items.status": "Complete,Returned,Cancelled"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 319,
    "model": "agentic_thelook",
    "name": "order_items_2024_w1_retained_profit_and_archetype_metrics"
  },
  "agentic_thelook.order_items_department_units_2024_01_01": {
    "assert": {
      "department_units_partition_total": {
        "expression": "${order_items_products_fields.mens_units} + ${order_items_products_fields.womens_units} = ${order_items.count}"
      },
      "mens_units_matches": {
        "expression": "${order_items_products_fields.mens_units} = 25"
      },
      "womens_units_matches": {
        "expression": "${order_items_products_fields.womens_units} = 30"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "count": {
            "field": "order_items.count"
          },
          "mens_units": {
            "field": "order_items_products_fields.mens_units"
          },
          "womens_units": {
            "field": "order_items_products_fields.womens_units"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/order_items.test.lkml",
    "line": 223,
    "model": "agentic_thelook",
    "name": "order_items_department_units_2024_01_01"
  },
  "agentic_thelook.order_items_midnight_owl_metrics": {
    "assert": {
      "late_night_revenue_matches": {
        "expression": "round(${order_items.late_night_revenue}, 2) = 1238.69"
      },
      "late_night_revenue_share_matches": {
        "expression": "round(${order_items.late_night_revenue_share}, 4) = 0.3467"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "late_night_revenue": {
            "field": "order_items.late_night_revenue"
          },
          "late_night_revenue_share": {
            "field": "order_items.late_night_revenue_share"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 74,
    "model": "agentic_thelook",
    "name": "order_items_midnight_owl_metrics"
  },
  "agentic_thelook.order_items_package_procrastination_metrics": {
    "assert": {
      "avg_hours_to_deliver_matches": {
        "expression": "round(${order_items.avg_hours_to_deliver}, 2) = 56.42"
      },
      "avg_hours_to_ship_matches": {
        "expression": "round(${order_items.avg_hours_to_ship}, 2) = 2.88"
      },
      "avg_total_doorstep_wait_hours_matches": {
        "expression": "round(${order_items.avg_total_doorstep_wait_hours}, 2) = 58.88"
      },
      "avg_truck_transit_hours_matches": {
        "expression": "round(${order_items.avg_truck_transit_hours}, 2) = 55.88"
      },
      "avg_warehouse_procrastination_hours_matches": {
        "expression": "round(${order_items.avg_warehouse_procrastination_hours}, 2) = 2.81"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_hours_to_deliver": {
            "field": "order_items.avg_hours_to_deliver"
          },
          "avg_hours_to_ship": {
            "field": "order_items.avg_hours_to_ship"
          },
          "avg_total_doorstep_wait_hours": {
            "field": "order_items.avg_total_doorstep_wait_hours"
          },
          "avg_truck_transit_hours": {
            "field": "order_items.avg_truck_transit_hours"
          },
          "avg_warehouse_procrastination_hours": {
            "field": "order_items.avg_warehouse_procrastination_hours"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.delivered_date": "2024-01-01",
          "order_items.is_delivered": "yes",
          "order_items.is_shipped": "yes",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 20,
    "model": "agentic_thelook",
    "name": "order_items_package_procrastination_metrics"
  },
  "agentic_thelook.order_items_refinement_metrics": {
    "assert": {
      "order_item_count_matches": {
        "expression": "${order_items.count} = 57"
      },
      "total_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 3662.74"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "order_item_count": {
            "field": "order_items.count"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "order_items_refinement_metrics"
  },
  "agentic_thelook.order_items_weekend_warrior_metrics": {
    "assert": {
      "avg_item_price_matches": {
        "expression": "round(${order_items.avg_item_price}, 2) = 56.71"
      },
      "distinct_orders_matches": {
        "expression": "${order_items.distinct_orders} = 59"
      }
    },
    "explore_source": {
      "order_items": {
        "column": {
          "avg_item_price": {
            "field": "order_items.avg_item_price"
          },
          "distinct_orders": {
            "field": "order_items.distinct_orders"
          }
        },
        "derived_column": null,
        "explore": "order_items",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items.test.lkml",
    "line": 57,
    "model": "agentic_thelook",
    "name": "order_items_weekend_warrior_metrics"
  },
  "agentic_thelook.order_shards_2024_01_01_metrics": {
    "assert": {
      "approx_distinct_users_matches": {
        "expression": "${order_shards.approx_distinct_users} = 73"
      },
      "shard_records_matches": {
        "expression": "${order_shards.count} = 117"
      }
    },
    "explore_source": {
      "order_shards": {
        "column": {
          "approx_distinct_users": {
            "field": "order_shards.approx_distinct_users"
          },
          "shard_records": {
            "field": "order_shards.count"
          }
        },
        "derived_column": null,
        "explore": "order_shards",
        "expression_custom_filter": null,
        "filters": {
          "order_shards.created_date": "2024-01-01",
          "order_shards.table_suffix": "s, ^_items",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_shards.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "order_shards_2024_01_01_metrics"
  },
  "agentic_thelook.order_shards_2024_01_01_wildcard_table_grain": {
    "assert": {
      "wildcard_table_grain_counts_match": {
        "expression": "index(${order_shards.wildcard_table_grain}, 1) = \"Order Header Shard (orders)\" AND index(${order_shards.count}, 1) = 52 AND index(${order_shards.wildcard_table_grain}, 2) = \"Order Line-Item Shard (order_items)\" AND index(${order_shards.count}, 2) = 55"
      }
    },
    "explore_source": {
      "order_shards": {
        "column": {
          "count": {
            "field": "order_shards.count"
          },
          "wildcard_table_grain": {
            "field": "order_shards.wildcard_table_grain"
          }
        },
        "derived_column": null,
        "explore": "order_shards",
        "expression_custom_filter": null,
        "filters": {
          "order_shards.created_date": "2024-01-01",
          "order_shards.table_suffix": "s, ^_items"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_shards.test.lkml",
    "line": 24,
    "model": "agentic_thelook",
    "name": "order_shards_2024_01_01_wildcard_table_grain"
  },
  "agentic_thelook.orders_2024_01_01_circadian_chronotype_metrics": {
    "assert": {
      "couch_prime_time_binger_matches": {
        "expression": "index(${orders.circadian_chronotype}, 4) = \"4. Couch Prime-Time Binger (18-23 UTC)\" AND index(${orders.count}, 4) = 15 AND index(${orders.total_items}, 4) = 24"
      },
      "morning_coffee_browser_matches": {
        "expression": "index(${orders.circadian_chronotype}, 2) = \"2. Morning Coffee Browser (06-11 UTC)\" AND index(${orders.count}, 2) = 11 AND index(${orders.total_items}, 2) = 13"
      },
      "vampire_insomnia_shopper_matches": {
        "expression": "index(${orders.circadian_chronotype}, 1) = \"1. Vampire Insomnia Shopper (00-05 UTC)\" AND index(${orders.count}, 1) = 13 AND index(${orders.total_items}, 1) = 19"
      },
      "wfh_procrastinator_matches": {
        "expression": "index(${orders.circadian_chronotype}, 3) = \"3. Work-From-Home Procrastinator (12-17 UTC)\" AND index(${orders.count}, 3) = 13 AND index(${orders.total_items}, 3) = 20"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "circadian_chronotype": {
            "field": "orders.circadian_chronotype"
          },
          "order_count": {
            "field": "orders.count"
          },
          "total_items": {
            "field": "orders.total_items"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "orders.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/orders.test.lkml",
    "line": 88,
    "model": "agentic_thelook",
    "name": "orders_2024_01_01_circadian_chronotype_metrics"
  },
  "agentic_thelook.orders_2024_01_01_distinct_users_metrics": {
    "assert": {
      "distinct_users_matches": {
        "expression": "${orders.distinct_users} = 51"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "distinct_users": {
            "field": "orders.distinct_users"
          },
          "order_count": {
            "field": "orders.count"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "orders.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/orders.test.lkml",
    "line": 45,
    "model": "agentic_thelook",
    "name": "orders_2024_01_01_distinct_users_metrics"
  },
  "agentic_thelook.orders_2024_01_01_mega_basket_bulk_orders_metrics": {
    "assert": {
      "mega_basket_avg_items_per_order_matches": {
        "expression": "round(${orders.avg_items_per_order}, 3) = 3.429"
      },
      "mega_basket_max_items_per_order_matches": {
        "expression": "${orders.max_items_per_order} = 4"
      },
      "mega_basket_order_count_matches": {
        "expression": "${orders.count} = 7"
      },
      "mega_basket_total_items_matches": {
        "expression": "${orders.total_items} = 24"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "avg_items_per_order": {
            "field": "orders.avg_items_per_order"
          },
          "max_items_per_order": {
            "field": "orders.max_items_per_order"
          },
          "order_count": {
            "field": "orders.count"
          },
          "total_items": {
            "field": "orders.total_items"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "orders.created_date": "2024-01-01",
          "orders.is_mega_basket_bulk_order": "yes",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/orders.test.lkml",
    "line": 59,
    "model": "agentic_thelook",
    "name": "orders_2024_01_01_mega_basket_bulk_orders_metrics"
  },
  "agentic_thelook.orders_2024_01_01_remorse_metrics": {
    "assert": {
      "cancelled_or_returned_orders_matches": {
        "expression": "${orders.cancelled_or_returned_orders} = 15"
      },
      "total_items_matches": {
        "expression": "${orders.total_items} = 71"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "cancelled_or_returned_orders": {
            "field": "orders.cancelled_or_returned_orders"
          },
          "total_items": {
            "field": "orders.total_items"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "orders.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/orders.test.lkml",
    "line": 28,
    "model": "agentic_thelook",
    "name": "orders_2024_01_01_remorse_metrics"
  },
  "agentic_thelook.orders_2024_01_purchase_cooldown_metrics": {
    "assert": {
      "avg_dopamine_cooldown_days_matches": {
        "expression": "round(${order_purchase_cooldowns.avg_dopamine_cooldown_days}, 2) = 428.95"
      },
      "avg_whole_cooldown_days_matches": {
        "expression": "round(${order_purchase_cooldowns.avg_whole_cooldown_days}, 2) = 428.45"
      },
      "max_cooldown_days_matches": {
        "expression": "${order_purchase_cooldowns.max_cooldown_days} = 1618"
      },
      "min_cooldown_hours_matches": {
        "expression": "round(${order_purchase_cooldowns.min_cooldown_hours}, 2) = 30.78"
      },
      "repeat_orders_matches": {
        "expression": "${order_purchase_cooldowns.repeat_orders} = 462"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "avg_dopamine_cooldown_days": {
            "field": "order_purchase_cooldowns.avg_dopamine_cooldown_days"
          },
          "avg_whole_cooldown_days": {
            "field": "order_purchase_cooldowns.avg_whole_cooldown_days"
          },
          "max_cooldown_days": {
            "field": "order_purchase_cooldowns.max_cooldown_days"
          },
          "min_cooldown_hours": {
            "field": "order_purchase_cooldowns.min_cooldown_hours"
          },
          "repeat_orders": {
            "field": "order_purchase_cooldowns.repeat_orders"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "order_purchase_cooldowns.is_repeat_order": "yes",
          "orders.created_date": "2024-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/orders.test.lkml",
    "line": 76,
    "model": "agentic_thelook",
    "name": "orders_2024_01_purchase_cooldown_metrics"
  },
  "agentic_thelook.orders_2024_01_repeat_spend_escalation": {
    "assert": {
      "step_one_baseline_identity": {
        "expression": "index(${user_spend_trajectory_facts.order_sequence_number}, 1) = 1 AND round(index(${user_spend_trajectory_facts.avg_spend_escalation_multiplier}, 1), 3) = 1 AND round(index(${user_spend_trajectory_facts.avg_order_spend}, 1), 2) = round(index(${user_spend_trajectory_facts.avg_first_order_spend}, 1), 2)"
      },
      "step_two_escalation_populated": {
        "expression": "index(${user_spend_trajectory_facts.order_sequence_number}, 2) = 2 AND index(${orders.distinct_users}, 2) > 0 AND index(${user_spend_trajectory_facts.avg_spend_escalation_multiplier}, 2) > 0"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "avg_first_order_spend": {
            "field": "user_spend_trajectory_facts.avg_first_order_spend"
          },
          "avg_order_spend": {
            "field": "user_spend_trajectory_facts.avg_order_spend"
          },
          "avg_spend_escalation_multiplier": {
            "field": "user_spend_trajectory_facts.avg_spend_escalation_multiplier"
          },
          "distinct_users": {
            "field": "orders.distinct_users"
          },
          "order_sequence_number": {
            "field": "user_spend_trajectory_facts.order_sequence_number"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "orders.created_month": "2024-01",
          "user_spend_trajectory_facts.user_order_count": ">=2"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/orders.test.lkml",
    "line": 55,
    "model": "agentic_thelook",
    "name": "orders_2024_01_repeat_spend_escalation"
  },
  "agentic_thelook.orders_2024_06_01_inter_order_gap_metrics": {
    "assert": {
      "max_inter_order_gap_and_count_match": {
        "expression": "${orders_sequenced.max_inter_order_gap_days} = 663 AND ${orders.count} = 21"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "count": {
            "field": "orders.count"
          },
          "max_inter_order_gap_days": {
            "field": "orders_sequenced.max_inter_order_gap_days"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "orders.created_date": "2024-06-01",
          "orders.status": "Complete,Returned,Cancelled"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/orders.test.lkml",
    "line": 40,
    "model": "agentic_thelook",
    "name": "orders_2024_06_01_inter_order_gap_metrics"
  },
  "agentic_thelook.orders_complete_basket_diversity_2024_01_01": {
    "assert": {
      "dual_category_basket_metrics_match": {
        "expression": "index(${order_basket_facts.basket_diversity_archetype}, 2) = \"Dual-Category Mix-and-Matcher (2 Categories)\" AND index(${orders.count}, 2) = 7 AND round(index(${order_basket_facts.avg_basket_spend}, 2), 2) = 145.59 AND round(index(${order_basket_facts.total_basket_revenue}, 2), 2) = 1019.12"
      },
      "outfit_builder_basket_metrics_match": {
        "expression": "index(${order_basket_facts.basket_diversity_archetype}, 1) = \"Head-to-Toe Complete Outfit Builder (3+ Distinct Categories)\" AND index(${orders.count}, 1) = 1 AND round(index(${order_basket_facts.avg_basket_units}, 1), 2) = 4 AND round(index(${order_basket_facts.avg_basket_distinct_brands}, 1), 2) = 4 AND round(index(${order_basket_facts.avg_basket_spend}, 1), 2) = 178.44 AND round(index(${order_basket_facts.total_basket_revenue}, 1), 2) = 178.44"
      },
      "solo_sniper_basket_metrics_match": {
        "expression": "index(${order_basket_facts.basket_diversity_archetype}, 3) = \"Solo Item Sniper (1 Unit Total)\" AND index(${orders.count}, 3) = 11 AND round(index(${order_basket_facts.avg_basket_spend}, 3), 2) = 61.38 AND round(index(${order_basket_facts.total_basket_revenue}, 3), 2) = 675.14"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "avg_basket_distinct_brands": {
            "field": "order_basket_facts.avg_basket_distinct_brands"
          },
          "avg_basket_spend": {
            "field": "order_basket_facts.avg_basket_spend"
          },
          "avg_basket_units": {
            "field": "order_basket_facts.avg_basket_units"
          },
          "basket_diversity_archetype": {
            "field": "order_basket_facts.basket_diversity_archetype"
          },
          "count": {
            "field": "orders.count"
          },
          "total_basket_revenue": {
            "field": "order_basket_facts.total_basket_revenue"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "order_basket_facts.order_id": "NOT NULL",
          "orders.created_date": "2024-01-01",
          "orders.status": "Complete"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/orders.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "orders_complete_basket_diversity_2024_01_01"
  },
  "agentic_thelook.orders_refinement_metrics": {
    "assert": {
      "avg_items_per_order_matches": {
        "expression": "round(${orders.avg_items_per_order}, 2) = 1.31"
      },
      "max_items_per_order_matches": {
        "expression": "${orders.max_items_per_order} = 3"
      },
      "order_count_matches": {
        "expression": "${orders.count} = 36"
      },
      "stddev_items_per_order_matches": {
        "expression": "round(${orders.stddev_items_per_order}, 2) = 0.58"
      }
    },
    "explore_source": {
      "orders": {
        "column": {
          "avg_items_per_order": {
            "field": "orders.avg_items_per_order"
          },
          "max_items_per_order": {
            "field": "orders.max_items_per_order"
          },
          "order_count": {
            "field": "orders.count"
          },
          "stddev_items_per_order": {
            "field": "orders.stddev_items_per_order"
          }
        },
        "derived_column": null,
        "explore": "orders",
        "expression_custom_filter": null,
        "filters": {
          "orders.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/orders.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "orders_refinement_metrics"
  },
  "agentic_thelook.products_2024_01_01_activity_weighted_retail_price": {
    "assert": {
      "avg_activity_weighted_retail_price_matches": {
        "expression": "round(${order_items_products_fields.avg_activity_weighted_retail_price}, 2) = 54.47"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "avg_activity_weighted_retail_price": {
            "field": "order_items_products_fields.avg_activity_weighted_retail_price"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "products.id": "NOT NULL"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/products.test.lkml",
    "line": 44,
    "model": "agentic_thelook",
    "name": "products_2024_01_01_activity_weighted_retail_price"
  },
  "agentic_thelook.products_2024_01_01_order_items_join_metrics": {
    "assert": {
      "products_and_units_match": {
        "expression": "${products.count} = 55 AND ${order_items.count} = 55"
      },
      "revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 2995.96"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "sku_count": {
            "field": "products.count"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          },
          "units_sold": {
            "field": "order_items.count"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/products.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "products_2024_01_01_order_items_join_metrics"
  },
  "agentic_thelook.products_2024_01_01_title_buzzword_revenue": {
    "assert": {
      "avg_item_weighted_word_offset_matches": {
        "expression": "round(${order_items_products_products__name_tokens_fields.avg_item_weighted_word_offset}, 2) = 3.14"
      },
      "token_weighted_units_matches": {
        "expression": "${order_items_products_products__name_tokens_fields.token_weighted_units_sold} = 112"
      },
      "total_token_weighted_revenue_matches": {
        "expression": "round(${order_items_products_products__name_tokens_fields.total_token_weighted_revenue}, 2) = 7484.97"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "avg_item_weighted_word_offset": {
            "field": "order_items_products_products__name_tokens_fields.avg_item_weighted_word_offset"
          },
          "count": {
            "field": "products.count"
          },
          "token_weighted_units_sold": {
            "field": "order_items_products_products__name_tokens_fields.token_weighted_units_sold"
          },
          "total_token_weighted_revenue": {
            "field": "order_items_products_products__name_tokens_fields.total_token_weighted_revenue"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "order_items.status": "Complete",
          "products__name_tokens.token_length": ">=4"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/products.test.lkml",
    "line": 147,
    "model": "agentic_thelook",
    "name": "products_2024_01_01_title_buzzword_revenue"
  },
  "agentic_thelook.products_brand_unit_velocity_invariants": {
    "assert": {
      "avg_units_sold_per_brand_matches_ratio": {
        "expression": "round(1.0 * ${order_items.count} / ${products.distinct_brands}, 6) = round(${order_items_products_fields.avg_units_sold_per_brand}, 6)"
      },
      "brand_count_positive": {
        "expression": "${products.distinct_brands} > 0 AND ${order_items.count} >= 0"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "avg_units_sold_per_brand": {
            "field": "order_items_products_fields.avg_units_sold_per_brand"
          },
          "distinct_brands": {
            "field": "products.distinct_brands"
          },
          "units_sold": {
            "field": "order_items.count"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.id": "<=1000",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/products.test.lkml",
    "line": 170,
    "model": "agentic_thelook",
    "name": "products_brand_unit_velocity_invariants"
  },
  "agentic_thelook.products_id_500_title_verbosity_and_tokens": {
    "assert": {
      "avg_word_position_matches": {
        "expression": "round(${products__name_tokens.avg_word_position_in_title}, 2) = 4.13"
      },
      "max_title_word_count_matches": {
        "expression": "${products.max_title_word_count} = 20"
      },
      "token_count_matches": {
        "expression": "${products__name_tokens.count} = 3601"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "avg_word_position_in_title": {
            "field": "products__name_tokens.avg_word_position_in_title"
          },
          "count": {
            "field": "products.count"
          },
          "max_title_word_count": {
            "field": "products.max_title_word_count"
          },
          "token_count": {
            "field": "products__name_tokens.count"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.id": "<=500",
          "products__name_tokens.token_length": ">=4"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/products.test.lkml",
    "line": 85,
    "model": "agentic_thelook",
    "name": "products_id_500_title_verbosity_and_tokens"
  },
  "agentic_thelook.products_id_le_1000_brand_lineup_roles": {
    "assert": {
      "lineup_metrics_consistent": {
        "expression": "${product_sales_facts.total_units_sold} >= 0 AND ${product_sales_facts.total_sku_revenue} >= ${product_sales_facts.total_sku_profit}"
      },
      "sku_count_positive": {
        "expression": "${products.count} > 0"
      },
      "strategic_role_populated": {
        "expression": "NOT is_null(${brand_sku_facts.brand_lineup_strategic_role})"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "brand_lineup_strategic_role": {
            "field": "brand_sku_facts.brand_lineup_strategic_role"
          },
          "sku_count": {
            "field": "products.count"
          },
          "total_sku_profit": {
            "field": "product_sales_facts.total_sku_profit"
          },
          "total_sku_revenue": {
            "field": "product_sales_facts.total_sku_revenue"
          },
          "total_units_sold": {
            "field": "product_sales_facts.total_units_sold"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.brand": "-NULL",
          "products.id": "<=1000",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/products.test.lkml",
    "line": 74,
    "model": "agentic_thelook",
    "name": "products_id_le_1000_brand_lineup_roles"
  },
  "agentic_thelook.products_id_le_1000_distinct_brands": {
    "assert": {
      "distinct_brands_matches": {
        "expression": "${products.distinct_brands} = 258"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "distinct_brands": {
            "field": "products.distinct_brands"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/products.test.lkml",
    "line": 75,
    "model": "agentic_thelook",
    "name": "products_id_le_1000_distinct_brands"
  },
  "agentic_thelook.products_id_le_1000_margin_and_anatomy_metrics": {
    "assert": {
      "commodity_grinder_tier_row_matches": {
        "expression": "index(${products.gross_margin_tier}, 4) = \"Commodity Margin Grinder (<$40 profit & <55% margin)\" AND index(${products.count}, 4) = 797 AND index(${products.distinct_categories}, 4) = 2 AND round(index(${products.min_retail_price}, 4), 2) = 3.11 AND round(index(${products.max_retail_price}, 4), 2) = 92"
      },
      "golden_goose_tier_row_matches": {
        "expression": "index(${products.gross_margin_tier}, 1) = \"Golden Goose Cash Cow ($40+ profit & 55%+ margin)\" AND index(${products.wardrobe_anatomy_zone}, 1) = \"Upper Torso, Outerwear & Accessories Zone\" AND index(${products.count}, 1) = 43 AND index(${products.distinct_categories}, 1) = 1 AND round(index(${products.min_retail_price}, 1), 2) = 74.99 AND round(index(${products.max_retail_price}, 1), 2) = 352"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "count": {
            "field": "products.count"
          },
          "distinct_categories": {
            "field": "products.distinct_categories"
          },
          "gross_margin_tier": {
            "field": "products.gross_margin_tier"
          },
          "max_retail_price": {
            "field": "products.max_retail_price"
          },
          "min_retail_price": {
            "field": "products.min_retail_price"
          },
          "wardrobe_anatomy_zone": {
            "field": "products.wardrobe_anatomy_zone"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.id": "<=1000",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/products.test.lkml",
    "line": 53,
    "model": "agentic_thelook",
    "name": "products_id_le_1000_margin_and_anatomy_metrics"
  },
  "agentic_thelook.products_id_le_1000_price_tier_metrics": {
    "assert": {
      "couture_tier_matches": {
        "expression": "index(${products.price_tier}, 4) = \"4. Trust-Fund Couture ($200+)\" AND index(${products.count}, 4) = 18 AND round(index(${products.avg_wholesale_cost}, 4), 2) = 131.58"
      },
      "designer_tier_matches": {
        "expression": "index(${products.price_tier}, 3) = \"3. Treat-Yo-Self Designer ($75-$200)\" AND index(${products.count}, 3) = 140 AND round(index(${products.avg_wholesale_cost}, 3), 2) = 54.80"
      },
      "impulse_tier_matches": {
        "expression": "index(${products.price_tier}, 1) = \"1. Impulse Pocket Change (<$25)\" AND index(${products.count}, 1) = 350 AND round(index(${products.avg_wholesale_cost}, 1), 2) = 8.77"
      },
      "staple_tier_matches": {
        "expression": "index(${products.price_tier}, 2) = \"2. Everyday Mall Staple ($25-$75)\" AND index(${products.count}, 2) = 492 AND round(index(${products.avg_wholesale_cost}, 2), 2) = 22.67"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "avg_wholesale_cost": {
            "field": "products.avg_wholesale_cost"
          },
          "count": {
            "field": "products.count"
          },
          "price_tier": {
            "field": "products.price_tier"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.id": "<=1000",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/products.test.lkml",
    "line": 28,
    "model": "agentic_thelook",
    "name": "products_id_le_1000_price_tier_metrics"
  },
  "agentic_thelook.products_id_le_1000_sku_velocity_invariants": {
    "assert": {
      "catalog_slice_partitions_all_1000_skus": {
        "expression": "sum(${products.count}) = 1000"
      },
      "hero_and_steady_mover_velocity_bounds_hold": {
        "expression": "index(${product_sales_facts.sku_velocity_tier}, 1) = \"Viral Hero SKU (5+ Units Sold)\" AND index(${order_items.count}, 1) >= 5 * index(${products.count}, 1) AND index(${product_sales_facts.sku_velocity_tier}, 2) = \"Steady Mover (2-4 Units Sold)\" AND index(${order_items.count}, 2) >= 2 * index(${products.count}, 2) AND index(${order_items.count}, 2) <= 4 * index(${products.count}, 2)"
      },
      "single_sale_and_wallflower_bounds_hold": {
        "expression": "index(${product_sales_facts.sku_velocity_tier}, 3) = \"Lonely Single-Sale SKU (1 Unit Sold)\" AND index(${order_items.count}, 3) = index(${products.count}, 3) AND index(${product_sales_facts.sku_velocity_tier}, 4) = \"Unloved Zero-Sale Wallflower (0 Sold)\" AND index(${order_items.count}, 4) = 0 AND index(${order_items.total_revenue}, 4) = 0"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "sku_count": {
            "field": "products.count"
          },
          "sku_velocity_tier": {
            "field": "product_sales_facts.sku_velocity_tier"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          },
          "units_sold": {
            "field": "order_items.count"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.id": "<=1000",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/products.test.lkml",
    "line": 21,
    "model": "agentic_thelook",
    "name": "products_id_le_1000_sku_velocity_invariants"
  },
  "agentic_thelook.products_id_le_5000_brand_prestige_invariants": {
    "assert": {
      "brand_prestige_tier_populated_and_bounded": {
        "expression": "NOT is_null(${brand_facts.brand_prestige_tier}) AND ${products.distinct_brands} > 0 AND ${products.count} >= ${products.distinct_brands}"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "brand_prestige_tier": {
            "field": "brand_facts.brand_prestige_tier"
          },
          "distinct_brands": {
            "field": "products.distinct_brands"
          },
          "sku_count": {
            "field": "products.count"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.brand": "-NULL",
          "products.id": "<=5000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/products.test.lkml",
    "line": 57,
    "model": "agentic_thelook",
    "name": "products_id_le_5000_brand_prestige_invariants"
  },
  "agentic_thelook.products_jeans_outliers_and_inventory_invariants": {
    "assert": {
      "jeans_sku_count_positive": {
        "expression": "${products.count} >= 1000"
      },
      "jeans_warehouses_matches": {
        "expression": "${distribution_centers.count} = 10"
      },
      "jeans_z_score_mean_is_zero": {
        "expression": "round(${category_sku_price_facts.avg_category_price_z_score}, 4) = 0"
      },
      "sold_units_positive": {
        "expression": "${product_inventory_facts.total_sold_units} >= 1"
      },
      "unsold_capital_non_negative": {
        "expression": "${product_inventory_facts.total_unsold_capital_value} >= 0"
      },
      "unsold_units_non_negative": {
        "expression": "${product_inventory_facts.total_unsold_available_units} >= 0"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "avg_category_price_z_score": {
            "field": "category_sku_price_facts.avg_category_price_z_score"
          },
          "sku_count": {
            "field": "products.count"
          },
          "total_sold_units": {
            "field": "product_inventory_facts.total_sold_units"
          },
          "total_unsold_available_units": {
            "field": "product_inventory_facts.total_unsold_available_units"
          },
          "total_unsold_capital_value": {
            "field": "product_inventory_facts.total_unsold_capital_value"
          },
          "warehouse_count": {
            "field": "distribution_centers.count"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "category_sku_price_facts.category_price_outlier_term": "-EMPTY",
          "distribution_centers.id": "NOT NULL",
          "product_inventory_facts.replenishment_urgency_tier": "-EMPTY",
          "products.category": "Jeans",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/products.test.lkml",
    "line": 102,
    "model": "agentic_thelook",
    "name": "products_jeans_outliers_and_inventory_invariants"
  },
  "agentic_thelook.products_refinement_metrics": {
    "assert": {
      "avg_dollar_markup_matches": {
        "expression": "round(${products.avg_dollar_markup}, 2) = 21.95"
      },
      "avg_markup_greed_pct_matches": {
        "expression": "round(${products.avg_markup_greed_pct}, 2) = 81.16"
      },
      "avg_sticker_price_matches": {
        "expression": "round(${products.avg_sticker_price}, 2) = 49"
      },
      "product_count_matches": {
        "expression": "${products.count} = 1"
      }
    },
    "explore_source": {
      "products": {
        "column": {
          "avg_dollar_markup": {
            "field": "products.avg_dollar_markup"
          },
          "avg_markup_greed_pct": {
            "field": "products.avg_markup_greed_pct"
          },
          "avg_sticker_price": {
            "field": "products.avg_sticker_price"
          },
          "product_count": {
            "field": "products.count"
          }
        },
        "derived_column": null,
        "explore": "products",
        "expression_custom_filter": null,
        "filters": {
          "products.id": "1",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/products.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "products_refinement_metrics"
  },
  "agentic_thelook.session_journey_path_share_invariants": {
    "assert": {
      "converted_journey_share_bounds": {
        "expression": "${session_journey_path_facts.session_frequency} > 0 AND ${session_journey_path_facts.share_of_all_sessions} > 0 AND ${session_journey_path_facts.share_of_all_sessions} < 1"
      }
    },
    "explore_source": {
      "session_journey_path_facts": {
        "column": {
          "is_converted_to_purchase": {
            "field": "session_journey_path_facts.is_converted_to_purchase"
          },
          "session_frequency": {
            "field": "session_journey_path_facts.session_frequency"
          },
          "share_of_all_sessions": {
            "field": "session_journey_path_facts.share_of_all_sessions"
          }
        },
        "derived_column": null,
        "explore": "session_journey_path_facts",
        "expression_custom_filter": null,
        "filters": {
          "session_journey_path_facts.is_converted_to_purchase": "yes"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/session_journey_path_facts.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "session_journey_path_share_invariants"
  },
  "agentic_thelook.user_brand_facts_repeat_devotion_invariants": {
    "assert": {
      "devotee_counts_bounded": {
        "expression": "${user_brand_facts.count} > 0 AND ${user_brand_facts.repeat_brand_devotees} >= 0 AND ${user_brand_facts.repeat_brand_devotees} <= ${user_brand_facts.count} AND ${user_brand_facts.max_units_by_single_buyer} >= 1"
      },
      "repeat_rate_matches_ratio": {
        "expression": "round(1.0 * ${user_brand_facts.repeat_brand_devotees} / ${user_brand_facts.count}, 6) = round(${user_brand_facts.cult_devotion_repeat_rate}, 6)"
      }
    },
    "explore_source": {
      "user_brand_facts": {
        "column": {
          "cult_devotion_repeat_rate": {
            "field": "user_brand_facts.cult_devotion_repeat_rate"
          },
          "distinct_buyers": {
            "field": "user_brand_facts.count"
          },
          "max_units_by_single_buyer": {
            "field": "user_brand_facts.max_units_by_single_buyer"
          },
          "repeat_brand_devotees": {
            "field": "user_brand_facts.repeat_brand_devotees"
          }
        },
        "derived_column": null,
        "explore": "user_brand_facts",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "user_brand_facts.user_id": "<=5000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/user_brand_facts.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "user_brand_facts_repeat_devotion_invariants"
  },
  "agentic_thelook.users_2022_cohort_year_1_survival_metrics": {
    "assert": {
      "active_buyers_matches": {
        "expression": "${order_items.distinct_users} = 3182"
      },
      "buyer_activation_survival_rate_matches": {
        "expression": "round(${order_items_user_cohort_facts_fields.buyer_activation_survival_rate}, 4) = 0.2558"
      },
      "cohort_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 305644.78"
      },
      "initial_cohort_users_matches": {
        "expression": "${user_cohort_facts.initial_cohort_users} = 12441"
      },
      "revenue_per_cohort_user_matches": {
        "expression": "round(${order_items_user_cohort_facts_fields.revenue_per_cohort_user}, 2) = 24.57"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "active_buyers": {
            "field": "order_items.distinct_users"
          },
          "buyer_activation_survival_rate": {
            "field": "order_items_user_cohort_facts_fields.buyer_activation_survival_rate"
          },
          "cohort_revenue": {
            "field": "order_items.total_revenue"
          },
          "initial_cohort_users": {
            "field": "user_cohort_facts.initial_cohort_users"
          },
          "revenue_per_cohort_user": {
            "field": "order_items_user_cohort_facts_fields.revenue_per_cohort_user"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "order_items_users_fields.years_since_signup": "1",
          "type_": "filters",
          "users.cohort_signup_year": "2022"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 67,
    "model": "agentic_thelook",
    "name": "users_2022_cohort_year_1_survival_metrics"
  },
  "agentic_thelook.users_2024_01_01_age_and_region_metrics": {
    "assert": {
      "non_us_european_runway_null_us_fields_match": {
        "expression": "index(${users.global_macro_region}, 11) = \"European Runway\" AND is_null(index(${users.us_super_region}, 11)) AND is_null(index(${users.postal_code_zone}, 11)) AND index(${users.age_bucket}, 11) = \"Millennial Hustler (25-39)\" AND index(${users.age_decade}, 11) = 20 AND index(${users.age_decade_label}, 11) = \"20s Decade\" AND index(${users.count}, 11) = 2"
      },
      "north_america_sunbelt_row_matches": {
        "expression": "index(${users.global_macro_region}, 5) = \"North America\" AND index(${users.us_super_region}, 5) = \"US Sunbelt & South\" AND index(${users.postal_code_zone}, 5) = \"3\" AND index(${users.age_bucket}, 5) = \"Millennial Hustler (25-39)\" AND index(${users.age_decade}, 5) = 30 AND index(${users.age_decade_label}, 5) = \"30s Decade\" AND index(${users.count}, 5) = 2"
      },
      "north_america_west_coast_row_matches": {
        "expression": "index(${users.global_macro_region}, 1) = \"North America\" AND index(${users.us_super_region}, 1) = \"US West Coast & Pacific\" AND index(${users.postal_code_zone}, 1) = \"8\" AND index(${users.age_bucket}, 1) = \"Gen-X Boss (40-54)\" AND index(${users.age_decade}, 1) = 50 AND index(${users.age_decade_label}, 1) = \"50s Decade\" AND index(${users.count}, 1) = 1"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "age_bucket": {
            "field": "users.age_bucket"
          },
          "age_decade": {
            "field": "users.age_decade"
          },
          "age_decade_label": {
            "field": "users.age_decade_label"
          },
          "count": {
            "field": "users.count"
          },
          "global_macro_region": {
            "field": "users.global_macro_region"
          },
          "postal_code_zone": {
            "field": "users.postal_code_zone"
          },
          "us_super_region": {
            "field": "users.us_super_region"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 163,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_age_and_region_metrics"
  },
  "agentic_thelook.users_2024_01_01_geographic_reach_metrics": {
    "assert": {
      "avg_resident_age_max_bound": {
        "expression": "${users.avg_resident_age} <= 90"
      },
      "avg_resident_age_min_bound": {
        "expression": "${users.avg_resident_age} >= 12"
      },
      "distinct_cities_matches": {
        "expression": "${users.distinct_cities} = 37"
      },
      "distinct_postal_codes_matches": {
        "expression": "${users.distinct_postal_codes} = 38"
      },
      "distinct_states_matches": {
        "expression": "${users.distinct_states} = 32"
      },
      "user_count_matches": {
        "expression": "${users.count} = 38"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_resident_age": {
            "field": "users.avg_resident_age"
          },
          "count": {
            "field": "users.count"
          },
          "distinct_cities": {
            "field": "users.distinct_cities"
          },
          "distinct_postal_codes": {
            "field": "users.distinct_postal_codes"
          },
          "distinct_states": {
            "field": "users.distinct_states"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 255,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_geographic_reach_metrics"
  },
  "agentic_thelook.users_2024_01_01_ghost_account_metrics": {
    "assert": {
      "ghost_account_rate_at_most_one": {
        "expression": "${orders_users_fields.ghost_account_rate} <= 1"
      },
      "ghost_account_rate_formula_matches": {
        "expression": "round(${orders_users_fields.ghost_account_rate}, 4) = round(1.0 * ${orders_users_fields.ghost_users} / ${users.count}, 4)"
      },
      "ghost_account_rate_non_negative": {
        "expression": "${orders_users_fields.ghost_account_rate} >= 0"
      },
      "ghost_users_complement_matches": {
        "expression": "${orders_users_fields.ghost_users} = ${users.count} - ${orders.distinct_users}"
      },
      "ghost_users_non_negative": {
        "expression": "${orders_users_fields.ghost_users} >= 0"
      },
      "registered_users_matches": {
        "expression": "${users.count} = 33"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "buying_users": {
            "field": "orders.distinct_users"
          },
          "ghost_account_rate": {
            "field": "orders_users_fields.ghost_account_rate"
          },
          "ghost_users": {
            "field": "orders_users_fields.ghost_users"
          },
          "registered_users": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 36,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_ghost_account_metrics"
  },
  "agentic_thelook.users_2024_01_01_hemisphere_belt_metrics": {
    "assert": {
      "equatorial_tropics_sectors_match": {
        "expression": "index(${users.hemisphere_belt}, 5) = \"3. Equatorial Tropics (-23.5S to 23.5N)\" AND index(${users.longitude_sector}, 5) = \"Americas West\" AND index(${users.count}, 5) = 5 AND index(${users.longitude_sector}, 6) = \"Asia/Oceania East\" AND index(${users.count}, 6) = 3"
      },
      "frost_belt_europe_africa_matches": {
        "expression": "index(${users.hemisphere_belt}, 1) = \"1. Northern High-Latitude Frost Belt (>=50N)\" AND index(${users.longitude_sector}, 1) = \"Europe/Africa Prime\" AND index(${users.count}, 1) = 4"
      },
      "northern_temperate_sectors_match": {
        "expression": "index(${users.hemisphere_belt}, 2) = \"2. Northern Temperate Fashion Zone (23.5N to 50N)\" AND index(${users.longitude_sector}, 2) = \"Americas West\" AND index(${users.count}, 2) = 9 AND index(${users.longitude_sector}, 3) = \"Asia/Oceania East\" AND index(${users.count}, 3) = 8 AND index(${users.longitude_sector}, 4) = \"Europe/Africa Prime\" AND index(${users.count}, 4) = 5"
      },
      "southern_hemisphere_sectors_match": {
        "expression": "index(${users.hemisphere_belt}, 7) = \"4. Southern Hemisphere Down-Under (<-23.5S)\" AND index(${users.longitude_sector}, 7) = \"Americas West\" AND index(${users.count}, 7) = 2 AND index(${users.longitude_sector}, 8) = \"Asia/Oceania East\" AND index(${users.count}, 8) = 2"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "count": {
            "field": "users.count"
          },
          "hemisphere_belt": {
            "field": "users.hemisphere_belt"
          },
          "longitude_sector": {
            "field": "users.longitude_sector"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 116,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_hemisphere_belt_metrics"
  },
  "agentic_thelook.users_2024_01_01_latitude_metrics": {
    "assert": {
      "avg_abs_latitude_matches": {
        "expression": "round(${users.avg_abs_latitude}, 2) = 37.3"
      },
      "user_count_matches": {
        "expression": "${users.count} = 33"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_abs_latitude": {
            "field": "users.avg_abs_latitude"
          },
          "user_count": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 28,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_latitude_metrics"
  },
  "agentic_thelook.users_2024_01_01_new_customer_created_year_metrics": {
    "assert": {
      "signup_year_matches_2024": {
        "expression": "${users.cohort_signup_year} = 2024"
      },
      "user_count_matches": {
        "expression": "${users.count} = 38"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "cohort_signup_year": {
            "field": "users.cohort_signup_year"
          },
          "user_count": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 74,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_new_customer_created_year_metrics"
  },
  "agentic_thelook.users_2024_01_01_per_capita_spend_metrics": {
    "assert": {
      "avg_activity_weighted_user_age_matches": {
        "expression": "round(${order_items_users_fields.avg_activity_weighted_user_age}, 1) = 39.3"
      },
      "avg_customer_age_matches": {
        "expression": "round(${users.avg_customer_age}, 2) = 35.45"
      },
      "items_purchased_matches": {
        "expression": "${order_items.count} = 52"
      },
      "registered_users_matches": {
        "expression": "${users.count} = 38"
      },
      "revenue_per_registered_user_matches": {
        "expression": "round(${order_items_users_fields.revenue_per_registered_user}, 2) = 69.04"
      },
      "total_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 2623.38"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_activity_weighted_user_age": {
            "field": "order_items_users_fields.avg_activity_weighted_user_age"
          },
          "avg_customer_age": {
            "field": "users.avg_customer_age"
          },
          "items_purchased": {
            "field": "order_items.count"
          },
          "registered_users": {
            "field": "users.count"
          },
          "revenue_per_registered_user": {
            "field": "order_items_users_fields.revenue_per_registered_user"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_per_capita_spend_metrics"
  },
  "agentic_thelook.users_2024_01_01_postal_code_parity_metrics": {
    "assert": {
      "alphanumeric_postcode_metrics_match": {
        "expression": "index(${users.postal_code_parity}, 1) = \"Alphanumeric International Postcode\" AND index(${users.count}, 1) = 11 AND index(${users.distinct_countries}, 1) = 3"
      },
      "even_zip_aristocrat_metrics_match": {
        "expression": "index(${users.postal_code_parity}, 2) = \"Even-Zip Aristocrat\" AND index(${users.count}, 2) = 14 AND index(${users.distinct_countries}, 2) = 5"
      },
      "odd_zip_rebel_metrics_match": {
        "expression": "index(${users.postal_code_parity}, 3) = \"Odd-Zip Rebel\" AND index(${users.count}, 3) = 13 AND index(${users.distinct_countries}, 3) = 5"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "count": {
            "field": "users.count"
          },
          "distinct_countries": {
            "field": "users.distinct_countries"
          },
          "postal_code_parity": {
            "field": "users.postal_code_parity"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 141,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_postal_code_parity_metrics"
  },
  "agentic_thelook.users_2024_01_01_thoroughfare_tier_metrics": {
    "assert": {
      "cul_de_sac_tier_matches": {
        "expression": "index(${users.thoroughfare_tier}, 1) = \"2. Cul-de-Sac Court Royalty\" AND index(${users.count}, 1) = 8 AND round(index(${users.avg_customer_age}, 1), 2) = 44"
      },
      "mystery_lane_tier_matches": {
        "expression": "index(${users.thoroughfare_tier}, 3) = \"4. Mystery Lane / International Address\" AND index(${users.count}, 3) = 25 AND round(index(${users.avg_customer_age}, 3), 2) = 46.96"
      },
      "standard_street_tier_matches": {
        "expression": "index(${users.thoroughfare_tier}, 2) = \"3. Standard Street & Road Citizen\" AND index(${users.count}, 2) = 5 AND round(index(${users.avg_customer_age}, 2), 2) = 26.2"
      },
      "total_slice_users_matches": {
        "expression": "sum(${users.count}) = 38"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_customer_age": {
            "field": "users.avg_customer_age"
          },
          "thoroughfare_tier": {
            "field": "users.thoroughfare_tier"
          },
          "user_count": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 91,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_thoroughfare_tier_metrics"
  },
  "agentic_thelook.users_2024_01_01_vanity_and_life_stage_dims": {
    "assert": {
      "career_builder_row_matches": {
        "expression": "index(${users.life_stage_zone}, 8) = \"Career Builder (25-39)\" AND index(${users.first_initial}, 8) = \"J\" AND index(${users.full_name_letter_count}, 8) = 12"
      },
      "first_row_youth_vanity_matches": {
        "expression": "index(${users.life_stage_zone}, 1) = \"Youth Budget (<25)\" AND index(${users.first_initial}, 1) = \"A\" AND index(${users.full_name_letter_count}, 1) = 10 AND index(${users.count}, 1) = 1"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "count": {
            "field": "users.count"
          },
          "first_initial": {
            "field": "users.first_initial"
          },
          "full_name_letter_count": {
            "field": "users.full_name_letter_count"
          },
          "life_stage_zone": {
            "field": "users.life_stage_zone"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 287,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_vanity_and_life_stage_dims"
  },
  "agentic_thelook.users_2024_01_01_warehouse_proximity_metrics": {
    "assert": {
      "forklift_neighbor_avg_km_matches": {
        "expression": "round(index(${user_warehouse_proximity_facts.avg_nearest_dc_km}, 1), 1) = 92.9"
      },
      "forklift_neighbor_count_matches": {
        "expression": "index(${users.count}, 1) = 1"
      },
      "forklift_neighbor_tier_label_matches": {
        "expression": "index(${user_warehouse_proximity_facts.warehouse_proximity_tier}, 1) = \"Forklift Earshot Neighbor (<100 km to Warehouse)\""
      },
      "transoceanic_expedition_avg_km_matches": {
        "expression": "round(index(${user_warehouse_proximity_facts.avg_nearest_dc_km}, 4), 1) = 8380.8"
      },
      "transoceanic_expedition_count_matches": {
        "expression": "index(${users.count}, 4) = 29"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_nearest_dc_km": {
            "field": "user_warehouse_proximity_facts.avg_nearest_dc_km"
          },
          "count": {
            "field": "users.count"
          },
          "warehouse_proximity_tier": {
            "field": "user_warehouse_proximity_facts.warehouse_proximity_tier"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 293,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_warehouse_proximity_metrics"
  },
  "agentic_thelook.users_2024_01_01_young_customers_metrics": {
    "assert": {
      "avg_young_customer_age_matches": {
        "expression": "round(${users.avg_customer_age}, 2) = 19.2"
      },
      "oldest_young_customer_under_25": {
        "expression": "${users.oldest_shopper_age} = 24"
      },
      "young_customer_count_matches": {
        "expression": "${users.count} = 5"
      },
      "youngest_young_customer_age_matches": {
        "expression": "${users.youngest_shopper_age} = 12"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_customer_age": {
            "field": "users.avg_customer_age"
          },
          "oldest_shopper_age": {
            "field": "users.oldest_shopper_age"
          },
          "user_count": {
            "field": "users.count"
          },
          "youngest_shopper_age": {
            "field": "users.youngest_shopper_age"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01",
          "users.is_young_customer": "yes"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 45,
    "model": "agentic_thelook",
    "name": "users_2024_01_01_young_customers_metrics"
  },
  "agentic_thelook.users_2024_01_complete_post_signup_order_lag": {
    "assert": {
      "avg_days_from_signup_to_order_matches": {
        "expression": "round(${orders_users_fields.avg_days_from_signup_to_order}, 1) = 771.3"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_days_from_signup_to_order": {
            "field": "orders_users_fields.avg_days_from_signup_to_order"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "orders.created_date": "2024-01",
          "orders.status": "Complete",
          "orders_users_fields.is_post_signup_order": "yes",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 186,
    "model": "agentic_thelook",
    "name": "users_2024_01_complete_post_signup_order_lag"
  },
  "agentic_thelook.users_2024_01_name_phonetics_and_tokens": {
    "assert": {
      "name_phonetics_club_counts_match": {
        "expression": "index(${users.name_phonetics_club}, 1) = \"Marvel Superhero Alliterative Name (Same Initials)\" AND index(${users.count}, 1) = 66 AND index(${users.name_phonetics_club}, 2) = \"Double-Letter Geminate Name Club\" AND index(${users.count}, 2) = 375 AND index(${users.name_phonetics_club}, 3) = \"Regular Non-Alliterative Civilian\" AND index(${users.count}, 3) = 623"
      },
      "unnested_name_tokens_double_users": {
        "expression": "${users__name_tokens.count} = ${users.count} * 2"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "count": {
            "field": "users.count"
          },
          "name_phonetics_club": {
            "field": "users.name_phonetics_club"
          },
          "token_count": {
            "field": "users__name_tokens.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "users.created_date": "2024-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 195,
    "model": "agentic_thelook",
    "name": "users_2024_01_name_phonetics_and_tokens"
  },
  "agentic_thelook.users_channel_attribution_persona_invariants": {
    "assert": {
      "channel_bounds_by_persona": {
        "expression": "if( ${user_click_facts.channel_attribution_persona} = \"Single-Channel Purist (1 Channel Only)\", round(${user_click_facts.avg_channels_touched}, 4) = 1, if( ${user_click_facts.channel_attribution_persona} = \"Omnichannel Everywhere Enthusiast (3+ Channels)\", ${user_click_facts.avg_channels_touched} >= 3, ${user_click_facts.avg_channels_touched} >= 1 ) )"
      },
      "non_null_persona_and_positive_users": {
        "expression": "NOT is_null(${user_click_facts.channel_attribution_persona}) AND ${users.count} > 0"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_channels_touched": {
            "field": "user_click_facts.avg_channels_touched"
          },
          "channel_attribution_persona": {
            "field": "user_click_facts.channel_attribution_persona"
          },
          "count": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "user_click_facts.total_clicks": ">0",
          "users.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 241,
    "model": "agentic_thelook",
    "name": "users_channel_attribution_persona_invariants"
  },
  "agentic_thelook.users_closet_brand_entropy_invariants": {
    "assert": {
      "buyer_spend_exceeds_profit": {
        "expression": "${user_brand_entropy_facts.avg_buyer_spend} > 0 AND ${user_brand_entropy_facts.avg_buyer_spend} >= ${user_brand_entropy_facts.avg_buyer_profit}"
      },
      "closet_size_and_entropy_bounds_valid": {
        "expression": "${user_brand_entropy_facts.count} > 0 AND ${user_brand_entropy_facts.avg_items_in_closet} >= 3 AND ${user_brand_entropy_facts.avg_distinct_brands} >= 1 AND ${user_brand_entropy_facts.avg_distinct_brands} <= ${user_brand_entropy_facts.avg_items_in_closet} AND ${user_brand_entropy_facts.avg_shannon_entropy} >= 0"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_buyer_profit": {
            "field": "user_brand_entropy_facts.avg_buyer_profit"
          },
          "avg_buyer_spend": {
            "field": "user_brand_entropy_facts.avg_buyer_spend"
          },
          "avg_distinct_brands": {
            "field": "user_brand_entropy_facts.avg_distinct_brands"
          },
          "avg_items_in_closet": {
            "field": "user_brand_entropy_facts.avg_items_in_closet"
          },
          "avg_shannon_entropy": {
            "field": "user_brand_entropy_facts.avg_shannon_entropy"
          },
          "repeat_customers": {
            "field": "user_brand_entropy_facts.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "user_brand_entropy_facts.total_items": ">=3",
          "users.id": "<=5000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 440,
    "model": "agentic_thelook",
    "name": "users_closet_brand_entropy_invariants"
  },
  "agentic_thelook.users_department_allegiance_invariants": {
    "assert": {
      "event_weighted_revenue_at_least_lifetime_spend": {
        "expression": "round(${events_order_items_fields.total_event_weighted_revenue}, 2) >= round(${user_spend_facts.total_lifetime_spend}, 2)"
      },
      "non_null_allegiance_and_buyer_floor": {
        "expression": "NOT is_null(${user_spend_facts.department_allegiance}) AND ${users.count} > 0 AND ${user_spend_facts.total_items_bought} >= ${users.count} AND ${user_spend_facts.total_lifetime_spend} > 0"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "count": {
            "field": "users.count"
          },
          "department_allegiance": {
            "field": "user_spend_facts.department_allegiance"
          },
          "total_event_weighted_revenue": {
            "field": "events_order_items_fields.total_event_weighted_revenue"
          },
          "total_items_bought": {
            "field": "user_spend_facts.total_items_bought"
          },
          "total_lifetime_spend": {
            "field": "user_spend_facts.total_lifetime_spend"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "user_spend_facts.user_id": "NOT NULL",
          "users.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 269,
    "model": "agentic_thelook",
    "name": "users_department_allegiance_invariants"
  },
  "agentic_thelook.users_email_persona_and_us_state_2024_01_01": {
    "assert": {
      "long_aristocratic_handle_slice_matches": {
        "expression": "index(${users.email_handle_persona}, 2) = \"Long Aristocratic Handle (16+ Letters, No Digits)\" AND index(${users.count}, 2) = 2 AND index(${users.us_registered_users}, 2) = 1"
      },
      "short_alphabetic_handle_slice_matches": {
        "expression": "index(${users.email_handle_persona}, 1) = \"Short Clean Alphabetic Handle (<16 Letters, No Digits)\" AND index(${users.count}, 1) = 36 AND index(${users.us_registered_users}, 1) = 8"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "count": {
            "field": "users.count"
          },
          "email_handle_persona": {
            "field": "users.email_handle_persona"
          },
          "us_registered_users": {
            "field": "users.us_registered_users"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 235,
    "model": "agentic_thelook",
    "name": "users_email_persona_and_us_state_2024_01_01"
  },
  "agentic_thelook.users_first_1000_cognitive_friction_invariants": {
    "assert": {
      "cognitive_friction_exhaustive_and_bounded": {
        "expression": "NOT is_null(${user_click_facts_user_spend_facts_users_fields.cognitive_friction_tier}) AND ${users.count} > 0 AND ${user_click_facts.avg_user_sessions} >= 1 AND ${user_click_facts.avg_user_url_depth} >= 1"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_user_sessions": {
            "field": "user_click_facts.avg_user_sessions"
          },
          "avg_user_url_depth": {
            "field": "user_click_facts.avg_user_url_depth"
          },
          "cognitive_friction_tier": {
            "field": "user_click_facts_user_spend_facts_users_fields.cognitive_friction_tier"
          },
          "users_count": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "user_click_facts.user_id": "NOT NULL",
          "users.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 346,
    "model": "agentic_thelook",
    "name": "users_first_1000_cognitive_friction_invariants"
  },
  "agentic_thelook.users_first_1000_lifecycle_and_persona_invariants": {
    "assert": {
      "lifecycle_and_persona_exhaustive": {
        "expression": "NOT is_null(${user_click_facts_user_order_facts_users_fields.lifecycle_resurrection_state}) AND NOT is_null(${user_spend_facts_users_fields.four_d_customer_persona}) AND ${users.count} > 0 AND ${user_spend_facts.count} <= ${users.count}"
      },
      "spend_and_retained_profit_algebraic_bounds": {
        "expression": "${user_order_facts_users_fields.avg_user_lifetime_orders} >= 0 AND ${user_spend_facts_users_fields.avg_user_gross_spend} >= ${user_spend_facts_users_fields.avg_user_retained_profit} AND abs(${user_spend_facts_users_fields.total_user_retained_profit} - (${users.count} * ${user_spend_facts_users_fields.avg_user_retained_profit})) < 0.01"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "active_buyers": {
            "field": "user_spend_facts.count"
          },
          "avg_user_gross_spend": {
            "field": "user_spend_facts_users_fields.avg_user_gross_spend"
          },
          "avg_user_lifetime_orders": {
            "field": "user_order_facts_users_fields.avg_user_lifetime_orders"
          },
          "avg_user_retained_profit": {
            "field": "user_spend_facts_users_fields.avg_user_retained_profit"
          },
          "four_d_customer_persona": {
            "field": "user_spend_facts_users_fields.four_d_customer_persona"
          },
          "lifecycle_resurrection_state": {
            "field": "user_click_facts_user_order_facts_users_fields.lifecycle_resurrection_state"
          },
          "total_user_retained_profit": {
            "field": "user_spend_facts_users_fields.total_user_retained_profit"
          },
          "users_count": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "users.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 321,
    "model": "agentic_thelook",
    "name": "users_first_1000_lifecycle_and_persona_invariants"
  },
  "agentic_thelook.users_id_1000_nomad_and_browser_hopping_invariants": {
    "assert": {
      "nomad_mobility_bounds_valid": {
        "expression": "${users.count} > 0 AND ${user_click_facts.avg_cities_visited} >= 1 AND ${user_click_facts.away_from_home_event_share} >= 0 AND ${user_click_facts.away_from_home_event_share} <= 1"
      },
      "user_gross_spend_algebraic_identity": {
        "expression": "${user_spend_facts_users_fields.total_user_gross_spend} >= 0 AND round(${user_spend_facts_users_fields.total_user_gross_spend} / ${users.count}, 4) = round(${user_spend_facts_users_fields.avg_user_gross_spend}, 4)"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_cities_visited": {
            "field": "user_click_facts.avg_cities_visited"
          },
          "avg_user_gross_spend": {
            "field": "user_spend_facts_users_fields.avg_user_gross_spend"
          },
          "away_from_home_event_share": {
            "field": "user_click_facts.away_from_home_event_share"
          },
          "count": {
            "field": "users.count"
          },
          "total_user_gross_spend": {
            "field": "user_spend_facts_users_fields.total_user_gross_spend"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "user_click_facts.user_id": "NOT NULL",
          "users.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 365,
    "model": "agentic_thelook",
    "name": "users_id_1000_nomad_and_browser_hopping_invariants"
  },
  "agentic_thelook.users_id_le_1000_buyer_personas_invariants": {
    "assert": {
      "blended_margin_consistent": {
        "expression": "${user_spend_facts.total_lifetime_spend} > 0 AND ${user_spend_facts.total_lifetime_spend} >= ${user_spend_facts.total_lifetime_profit} AND round(${user_spend_facts.blended_lifetime_margin_ratio}, 6) = round(${user_spend_facts.total_lifetime_profit} / ${user_spend_facts.total_lifetime_spend}, 6)"
      },
      "buyer_count_positive": {
        "expression": "${users.count} > 0"
      },
      "personas_populated_for_buyers": {
        "expression": "NOT is_null(${user_order_facts_users_fields.activation_velocity_persona}) AND NOT is_null(${user_spend_facts.return_behavior_persona}) AND NOT is_null(${user_spend_facts.customer_margin_archetype}) AND NOT is_null(${user_spend_facts.national_wealth_tier})"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "activation_velocity_persona": {
            "field": "user_order_facts_users_fields.activation_velocity_persona"
          },
          "blended_lifetime_margin_ratio": {
            "field": "user_spend_facts.blended_lifetime_margin_ratio"
          },
          "buyer_count": {
            "field": "users.count"
          },
          "customer_margin_archetype": {
            "field": "user_spend_facts.customer_margin_archetype"
          },
          "national_wealth_tier": {
            "field": "user_spend_facts.national_wealth_tier"
          },
          "return_behavior_persona": {
            "field": "user_spend_facts.return_behavior_persona"
          },
          "total_lifetime_profit": {
            "field": "user_spend_facts.total_lifetime_profit"
          },
          "total_lifetime_spend": {
            "field": "user_spend_facts.total_lifetime_spend"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "user_order_facts.user_id": "NOT NULL",
          "user_spend_facts.user_id": "NOT NULL",
          "users.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 207,
    "model": "agentic_thelook",
    "name": "users_id_le_1000_buyer_personas_invariants"
  },
  "agentic_thelook.users_id_le_1000_loyalty_tier_invariants": {
    "assert": {
      "double_dipper_and_regular_order_bounds_hold": {
        "expression": "index(${user_order_facts.customer_loyalty_tier}, 3) = \"Repeat Double-Dipper (2 Orders)\" AND index(${orders.count}, 3) = 2 * index(${users.count}, 3) AND index(${user_order_facts.customer_loyalty_tier}, 4) = \"Cult Die-Hard Regular (3+ Orders)\" AND index(${orders.count}, 4) >= 3 * index(${users.count}, 4)"
      },
      "ghost_and_tourist_order_bounds_hold": {
        "expression": "index(${user_order_facts.customer_loyalty_tier}, 1) = \"Window-Shopping Ghost (0 Orders)\" AND index(${orders.count}, 1) = 0 AND index(${orders.total_items}, 1) = 0 AND index(${user_order_facts.customer_loyalty_tier}, 2) = \"One-and-Done Tourist (1 Order)\" AND index(${orders.count}, 2) = index(${users.count}, 2)"
      },
      "user_slice_partitions_all_1000_customers": {
        "expression": "sum(${users.count}) = 1000"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "customer_count": {
            "field": "users.count"
          },
          "customer_loyalty_tier": {
            "field": "user_order_facts.customer_loyalty_tier"
          },
          "items_contributed": {
            "field": "orders.total_items"
          },
          "orders_contributed": {
            "field": "orders.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 124,
    "model": "agentic_thelook",
    "name": "users_id_le_1000_loyalty_tier_invariants"
  },
  "agentic_thelook.users_id_le_1000_oceanic_spend_invariants": {
    "assert": {
      "dolphin_and_mega_whale_ltv_bounds_hold": {
        "expression": "index(${user_spend_facts.oceanic_spend_tier}, 3) = \"Dolphin ($100-$299 LTV)\" AND index(${user_spend_facts.avg_customer_ltv}, 3) >= 100 AND index(${user_spend_facts.avg_customer_ltv}, 3) < 300 AND index(${user_spend_facts.oceanic_spend_tier}, 4) = \"Moby Dick Mega-Whale ($300+ LTV)\" AND index(${user_spend_facts.avg_customer_ltv}, 4) >= 300"
      },
      "plankton_and_minnow_ltv_bounds_hold": {
        "expression": "index(${user_spend_facts.oceanic_spend_tier}, 1) = \"Plankton (<$30 LTV)\" AND index(${user_spend_facts.avg_customer_ltv}, 1) > 0 AND index(${user_spend_facts.avg_customer_ltv}, 1) < 30 AND index(${user_spend_facts.oceanic_spend_tier}, 2) = \"Minnow ($30-$99 LTV)\" AND index(${user_spend_facts.avg_customer_ltv}, 2) >= 30 AND index(${user_spend_facts.avg_customer_ltv}, 2) < 100"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_customer_ltv": {
            "field": "user_spend_facts.avg_customer_ltv"
          },
          "buyers_count": {
            "field": "users.count"
          },
          "oceanic_spend_tier": {
            "field": "user_spend_facts.oceanic_spend_tier"
          },
          "tier_total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "user_spend_facts.user_id": "NOT NULL",
          "users.id": "<=1000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 100,
    "model": "agentic_thelook",
    "name": "users_id_le_1000_oceanic_spend_invariants"
  },
  "agentic_thelook.users_id_le_5000_clickstream_intent_and_ratio_invariants": {
    "assert": {
      "clickstream_intent_personas_and_ratios_hold": {
        "expression": "NOT is_null(${user_click_facts_user_spend_facts_users_fields.clickstream_intent_persona}) AND ${users.count} > 0 AND ${user_click_facts_user_spend_facts_users_fields.avg_user_clicks} >= 0 AND ${user_click_facts_user_spend_facts_users_fields.avg_user_items_bought} >= 0 AND ( ${order_items.count} = 0 OR round(${events_order_items_fields.clicks_per_item_bought}, 4) = round(1.0 * ${events.count} / ${order_items.count}, 4) )"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_user_clicks": {
            "field": "user_click_facts_user_spend_facts_users_fields.avg_user_clicks"
          },
          "avg_user_items_bought": {
            "field": "user_click_facts_user_spend_facts_users_fields.avg_user_items_bought"
          },
          "clicks_per_item_bought": {
            "field": "events_order_items_fields.clicks_per_item_bought"
          },
          "clickstream_intent_persona": {
            "field": "user_click_facts_user_spend_facts_users_fields.clickstream_intent_persona"
          },
          "items_bought": {
            "field": "order_items.count"
          },
          "total_clicks": {
            "field": "events.count"
          },
          "users_count": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "users.id": "<=5000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 163,
    "model": "agentic_thelook",
    "name": "users_id_le_5000_clickstream_intent_and_ratio_invariants"
  },
  "agentic_thelook.users_id_le_5000_spend_trajectory_invariants": {
    "assert": {
      "escalator_spend_trajectory_holds": {
        "expression": "${users.count} > 0 AND ${user_spend_trajectory_facts.avg_latest_order_spend} >= 1.25 * ${user_spend_trajectory_facts.avg_first_order_spend}"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_first_order_spend": {
            "field": "user_spend_trajectory_facts.avg_first_order_spend"
          },
          "avg_latest_order_spend": {
            "field": "user_spend_trajectory_facts.avg_latest_order_spend"
          },
          "repeat_customers": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "user_spend_trajectory_facts.spend_trajectory_persona": "Big-Spender Escalator (Latest >= 1.25x First Order)",
          "users.id": "<=5000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 147,
    "model": "agentic_thelook",
    "name": "users_id_le_5000_spend_trajectory_invariants"
  },
  "agentic_thelook.users_id_le_5_full_name_metrics": {
    "assert": {
      "fifth_user_full_name_matches": {
        "expression": "index(${users.id}, 5) = 5 AND index(${users.full_name}, 5) = \"Nicholas Turner\" AND sum(${users.count}) = 5"
      },
      "first_user_full_name_matches": {
        "expression": "index(${users.id}, 1) = 1 AND index(${users.full_name}, 1) = \"Valerie Lowe\" AND index(${users.count}, 1) = 1"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "count": {
            "field": "users.count"
          },
          "full_name": {
            "field": "users.full_name"
          },
          "id": {
            "field": "users.id"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.id": "<=5"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 216,
    "model": "agentic_thelook",
    "name": "users_id_le_5_full_name_metrics"
  },
  "agentic_thelook.users_pareto_whale_concentration_invariants": {
    "assert": {
      "buyer_spend_bounds_valid": {
        "expression": "${user_pareto_facts.count} > 0 AND ${user_pareto_facts.min_lifetime_spend} > 0 AND ${user_pareto_facts.min_lifetime_spend} <= ${user_pareto_facts.max_lifetime_spend}"
      },
      "pareto_shares_monotonic_and_bounded": {
        "expression": "${user_pareto_facts.top_1_pct_revenue_share} >= 0 AND ${user_pareto_facts.top_1_pct_revenue_share} <= ${user_pareto_facts.top_10_pct_revenue_share} AND ${user_pareto_facts.top_10_pct_revenue_share} <= ${user_pareto_facts.top_20_pct_revenue_share} AND ${user_pareto_facts.top_20_pct_revenue_share} <= 1"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "buyer_count": {
            "field": "user_pareto_facts.count"
          },
          "max_lifetime_spend": {
            "field": "user_pareto_facts.max_lifetime_spend"
          },
          "min_lifetime_spend": {
            "field": "user_pareto_facts.min_lifetime_spend"
          },
          "top_10_pct_revenue_share": {
            "field": "user_pareto_facts.top_10_pct_revenue_share"
          },
          "top_1_pct_revenue_share": {
            "field": "user_pareto_facts.top_1_pct_revenue_share"
          },
          "top_20_pct_revenue_share": {
            "field": "user_pareto_facts.top_20_pct_revenue_share"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "user_pareto_facts.user_id": "NOT NULL",
          "users.id": "<=5000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 415,
    "model": "agentic_thelook",
    "name": "users_pareto_whale_concentration_invariants"
  },
  "agentic_thelook.users_refinement_metrics": {
    "assert": {
      "avg_customer_age_matches": {
        "expression": "round(${users.avg_customer_age}, 2) = 39.52"
      },
      "oldest_shopper_age_matches": {
        "expression": "${users.oldest_shopper_age} = 70"
      },
      "user_count_matches": {
        "expression": "${users.count} = 29"
      },
      "youngest_shopper_age_matches": {
        "expression": "${users.youngest_shopper_age} = 14"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "avg_customer_age": {
            "field": "users.avg_customer_age"
          },
          "oldest_shopper_age": {
            "field": "users.oldest_shopper_age"
          },
          "user_count": {
            "field": "users.count"
          },
          "youngest_shopper_age": {
            "field": "users.youngest_shopper_age"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "users_refinement_metrics"
  },
  "agentic_thelook.users_return_concentration_conversion_and_click_efficiency_invariants": {
    "assert": {
      "clicks_per_dollar_reciprocal_identity": {
        "expression": "${user_click_facts_user_spend_facts_users_fields.avg_clicks_per_dollar_spent} > 0 AND round(${user_click_facts_user_spend_facts_users_fields.clicks_per_dollar} * ${user_click_facts_user_spend_facts_users_fields.revenue_per_click}, 4) = 1"
      },
      "serial_returner_concentration_invariants": {
        "expression": "${user_spend_facts.serial_returner_users} <= ${user_spend_facts.any_returner_users} AND ${user_spend_facts.serial_returner_refund_dollars} <= ${user_spend_facts.total_refund_dollars} AND round(${user_spend_facts.serial_returner_refund_share}, 6) = round(${user_spend_facts.serial_returner_refund_dollars} / ${user_spend_facts.total_refund_dollars}, 6)"
      },
      "user_conversion_rate_algebraic_identity": {
        "expression": "${order_items_users_fields.user_conversion_rate} >= 0 AND ${order_items_users_fields.user_conversion_rate} <= 1 AND round(${order_items_users_fields.user_conversion_rate}, 6) = round(${order_items.distinct_users} / ${users.count}, 6)"
      }
    },
    "explore_source": {
      "users": {
        "column": {
          "any_returner_users": {
            "field": "user_spend_facts.any_returner_users"
          },
          "avg_clicks_per_dollar_spent": {
            "field": "user_click_facts_user_spend_facts_users_fields.avg_clicks_per_dollar_spent"
          },
          "clicks_per_dollar": {
            "field": "user_click_facts_user_spend_facts_users_fields.clicks_per_dollar"
          },
          "converting_buyers": {
            "field": "order_items.distinct_users"
          },
          "revenue_per_click": {
            "field": "user_click_facts_user_spend_facts_users_fields.revenue_per_click"
          },
          "serial_returner_refund_dollars": {
            "field": "user_spend_facts.serial_returner_refund_dollars"
          },
          "serial_returner_refund_share": {
            "field": "user_spend_facts.serial_returner_refund_share"
          },
          "serial_returner_users": {
            "field": "user_spend_facts.serial_returner_users"
          },
          "total_refund_dollars": {
            "field": "user_spend_facts.total_refund_dollars"
          },
          "user_conversion_rate": {
            "field": "order_items_users_fields.user_conversion_rate"
          },
          "user_count": {
            "field": "users.count"
          }
        },
        "derived_column": null,
        "explore": "users",
        "expression_custom_filter": null,
        "filters": {
          "users.id": "<=2000"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/silver/users.test.lkml",
    "line": 389,
    "model": "agentic_thelook",
    "name": "users_return_concentration_conversion_and_click_efficiency_invariants"
  }
}
