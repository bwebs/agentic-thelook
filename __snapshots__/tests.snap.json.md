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
