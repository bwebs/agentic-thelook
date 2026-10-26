{
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
  }
}
