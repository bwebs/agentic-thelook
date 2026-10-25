{
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
