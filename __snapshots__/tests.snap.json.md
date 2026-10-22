{
  "agentic_thelook.distribution_centers_base_refinement_metrics": {
    "assert": {
      "mean_warehouse_latitude_matches": {
        "expression": "round(${distribution_centers.mean_warehouse_latitude}, 4) = 35.1174"
      },
      "total_warehouses_matches": {
        "expression": "${distribution_centers.count} = 1"
      }
    },
    "explore_source": {
      "distribution_centers_base": {
        "column": {
          "mean_warehouse_latitude": {
            "field": "distribution_centers.mean_warehouse_latitude"
          },
          "total_warehouses": {
            "field": "distribution_centers.count"
          }
        },
        "derived_column": null,
        "explore": "distribution_centers_base",
        "expression_custom_filter": null,
        "filters": {
          "distribution_centers.id": "1",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/distribution_centers_base.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "distribution_centers_base_refinement_metrics"
  },
  "agentic_thelook.distribution_centers_metrics_at_fixed_id": {
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
    "file": "tests/silver/distribution_centers.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "distribution_centers_metrics_at_fixed_id"
  },
  "agentic_thelook.events_base_refinement_metrics": {
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
      "events_base": {
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
        "explore": "events_base",
        "expression_custom_filter": null,
        "filters": {
          "events.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/events_base.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "events_base_refinement_metrics"
  },
  "agentic_thelook.inventory_items_base_refinement_metrics": {
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
      "inventory_items_base": {
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
        "explore": "inventory_items_base",
        "expression_custom_filter": null,
        "filters": {
          "inventory_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/inventory_items_base.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "inventory_items_base_refinement_metrics"
  },
  "agentic_thelook.order_items_base_refinement_metrics": {
    "assert": {
      "order_item_count_matches": {
        "expression": "${order_items.count} = 57"
      },
      "total_revenue_matches": {
        "expression": "round(${order_items.total_revenue}, 2) = 3662.74"
      }
    },
    "explore_source": {
      "order_items_base": {
        "column": {
          "order_item_count": {
            "field": "order_items.count"
          },
          "total_revenue": {
            "field": "order_items.total_revenue"
          }
        },
        "derived_column": null,
        "explore": "order_items_base",
        "expression_custom_filter": null,
        "filters": {
          "order_items.created_date": "2024-01-01",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/order_items_base.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "order_items_base_refinement_metrics"
  },
  "agentic_thelook.order_items_fact_metrics_at_fixed_date": {
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
    "file": "tests/silver/order_items.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "order_items_fact_metrics_at_fixed_date"
  },
  "agentic_thelook.products_base_refinement_metrics": {
    "assert": {
      "avg_sticker_price_matches": {
        "expression": "round(${products.avg_sticker_price}, 2) = 49"
      },
      "product_count_matches": {
        "expression": "${products.count} = 1"
      }
    },
    "explore_source": {
      "products_base": {
        "column": {
          "avg_sticker_price": {
            "field": "products.avg_sticker_price"
          },
          "product_count": {
            "field": "products.count"
          }
        },
        "derived_column": null,
        "explore": "products_base",
        "expression_custom_filter": null,
        "filters": {
          "products.id": "1",
          "type_": "filters"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/products_base.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "products_base_refinement_metrics"
  },
  "agentic_thelook.products_catalog_metrics_at_fixed_id": {
    "assert": {
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
    "file": "tests/silver/products.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "products_catalog_metrics_at_fixed_id"
  },
  "agentic_thelook.users_base_refinement_metrics": {
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
      "users_base": {
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
        "explore": "users_base",
        "expression_custom_filter": null,
        "filters": {
          "type_": "filters",
          "users.created_date": "2024-01-01"
        },
        "limit": null,
        "timezone": null
      }
    },
    "file": "tests/bronze/users_base.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "users_base_refinement_metrics"
  },
  "agentic_thelook.users_metrics_at_fixed_date": {
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
    "file": "tests/silver/users.test.lkml",
    "line": 3,
    "model": "agentic_thelook",
    "name": "users_metrics_at_fixed_date"
  }
}
