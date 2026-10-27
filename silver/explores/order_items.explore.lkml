include: "/bronze/common_helpers.view.lkml"
include: "/bronze/order_items.view.lkml"
include: "/bronze/order_items.refinement.lkml"
include: "/bronze/orders.view.lkml"
include: "/bronze/orders.refinement.lkml"
include: "/bronze/products.view.lkml"
include: "/bronze/products.refinement.lkml"
include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/bronze/inventory_items.view.lkml"
include: "/bronze/inventory_items.refinement.lkml"
include: "/bronze/distribution_centers.view.lkml"
include: "/bronze/distribution_centers.refinement.lkml"
include: "/bronze/explores/order_items_base.explore.lkml"
include: "/silver/distribution_centers_order_items_users_fields.view.lkml"
include: "/silver/inventory_items_order_items_fields.view.lkml"
include: "/silver/order_items_products_fields.view.lkml"
include: "/silver/order_items_products_users_fields.view.lkml"
include: "/silver/order_items_users_fields.view.lkml"
include: "/silver/category_sku_price_facts.view.lkml"
include: "/silver/user_warehouse_proximity_facts.view.lkml"
include: "/silver/user_click_facts.view.lkml"
include: "/silver/user_item_volume_facts.view.lkml"
include: "/silver/order_items_user_click_facts_fields.view.lkml"
include: "/silver/category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.view.lkml"
include: "/silver/category_sales_facts.view.lkml"
include: "/silver/category_sales_facts_order_items_fields.view.lkml"
include: "/silver/distribution_centers_order_items_user_warehouse_proximity_facts_users_fields.view.lkml"

explore: order_items {
  extends: [order_items_base]
  label: "Order Items"
  view_name: order_items
  hidden: no
  fields: [
    ALL_FIELDS*,
    -products.markup_greed_pct,
    -products.avg_markup_greed_pct,
    -order_items_users_fields.revenue_per_registered_user,
    -order_items_users_fields.user_conversion_rate,
    -order_items_products_fields.avg_units_sold_per_brand
  ]

  join: common_helpers {
    sql: ;;
    relationship: one_to_one
  }

  join: orders {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.order_id} = ${orders.order_id} ;;
  }

  join: products {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.product_id} = ${products.id} ;;
  }

  join: users {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${users.id} ;;
  }

  join: inventory_items {
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
  }

  join: distribution_centers {
    type: left_outer
    relationship: many_to_one
    sql_on: ${inventory_items.product_distribution_center_id} = ${distribution_centers.id} ;;
  }

  join: order_items_products_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: order_items_products_users_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: order_items_users_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: inventory_items_order_items_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: distribution_centers_order_items_users_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: category_sku_price_facts {
    view_label: "Category Price Outlier Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.id} = ${category_sku_price_facts.product_id} ;;
    fields: [
      category_sku_price_facts.product_id,
      category_sku_price_facts.category_price_z_score,
      category_sku_price_facts.category_price_outlier_term
    ]
  }

  join: _sdt_distribution_centers {
    from: distribution_centers
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  join: user_warehouse_proximity_facts {
    view_label: "Customer Warehouse Proximity Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${user_warehouse_proximity_facts.id} ;;
    fields: [
      user_warehouse_proximity_facts.id,
      user_warehouse_proximity_facts.nearest_dc_km,
      user_warehouse_proximity_facts.nearest_warehouse_name,
      user_warehouse_proximity_facts.warehouse_proximity_tier
    ]
  }

  join: user_click_facts {
    view_label: "Customer Clickstream Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${users.id} = ${user_click_facts.user_id} ;;
    fields: [
      user_click_facts.user_id,
      user_click_facts.total_clicks,
      user_click_facts.distinct_event_sources,
      user_click_facts.latest_browser,
      user_click_facts.distinct_ips,
      user_click_facts.ip_nomad_tier,
      user_click_facts.distinct_browsers_used,
      user_click_facts.browser_combo
    ]
  }

  join: user_item_volume_facts {
    view_label: "Customer Item Volume Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${order_items.user_id} = ${user_item_volume_facts.user_id} ;;
  }

  join: order_items_user_click_facts_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: category_sales_facts {
    view_label: "Category Sold Price Facts"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.category} = ${category_sales_facts.category} ;;
  }

  join: category_sales_facts_order_items_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  join: product_distribution_centers {
    from: distribution_centers
    view_label: "Product Catalog Distribution Center"
    type: left_outer
    relationship: many_to_one
    sql_on: ${products.distribution_center_id} = ${product_distribution_centers.id} ;;
  }

  join: distribution_centers_order_items_user_warehouse_proximity_facts_users_fields {
    view_label: "Order Items"
    sql: ;;
    relationship: one_to_one
  }

  query: warehouse_department_assortment_and_theoretical_margin {
    description: "Catalog categories carried, outbound units shipped, and theoretical catalog margin broken down by product distribution center and department."
    dimensions: [
      product_distribution_centers.name,
      products.department
    ]
    measures: [
      products.distinct_categories,
      order_items.count,
      order_items_products_fields.total_theoretical_margin
    ]
    filters: [
      products.id: "NOT NULL",
      product_distribution_centers.id: "NOT NULL"
    ]
    sorts: [
      product_distribution_centers.name: asc,
      order_items.count: desc
    ]
  }

  query: top_cross_border_warehouse_country_corridors {
    description: "Top 20 international cross-border warehouse-to-country shipping corridors outside the United States ranked by cross-border gross revenue."
    dimensions: [
      product_distribution_centers.name,
      users.country
    ]
    measures: [
      order_items.count,
      order_items.total_revenue
    ]
    filters: [
      products.id: "NOT NULL",
      product_distribution_centers.id: "NOT NULL",
      users.id: "NOT NULL",
      users.country: "-United States,-NULL"
    ]
    sorts: [order_items.total_revenue: desc]
    limit: 20
  }

  query: us_logistics_routing_absurdity_summary {
    description: "Logistics Routing Absurdity Tax summary of domestic US shipments comparing optimal nearest-warehouse fulfillment against suboptimal detours, detour rate, average wasted km per item, and total wasted detour km."
    measures: [
      order_items.count,
      category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.optimal_nearest_warehouse_shipments,
      category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.suboptimal_detour_shipments,
      category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.routing_absurdity_rate,
      distribution_centers_order_items_user_warehouse_proximity_facts_users_fields.avg_wasted_detour_km,
      distribution_centers_order_items_user_warehouse_proximity_facts_users_fields.total_wasted_detour_km
    ]
    filters: [
      users.country: "United States",
      users.id: "NOT NULL",
      inventory_items.id: "NOT NULL",
      distribution_centers.id: "NOT NULL"
    ]
  }

  query: top_mismatched_us_warehouse_detour_pairs {
    description: "Top 15 domestic US warehouse routing mismatch corridors (actual shipping warehouse vs. closest catchment warehouse) ranked by detoured shipment count alongside average extra kilometers."
    dimensions: [
      distribution_centers.name,
      user_warehouse_proximity_facts.nearest_warehouse_name
    ]
    measures: [
      order_items.count,
      distribution_centers_order_items_user_warehouse_proximity_facts_users_fields.avg_wasted_detour_km
    ]
    filters: [
      users.country: "United States",
      users.id: "NOT NULL",
      inventory_items.id: "NOT NULL",
      distribution_centers.id: "NOT NULL",
      category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.is_shipped_from_nearest_dc: "no"
    ]
    sorts: [order_items.count: desc]
    limit: 15
  }

  query: top_customers_by_net_profit_contributed {
    description: "Top 15 individual buyers ranked by cumulative net profit contributed alongside customer name, age, country, orders placed, items bought, and gross spend."
    dimensions: [
      users.id,
      users.full_name,
      users.age,
      users.country
    ]
    measures: [
      order_items.distinct_orders,
      order_items.count,
      order_items.total_revenue,
      inventory_items_order_items_fields.total_gross_profit
    ]
    filters: [
      users.id: "NOT NULL",
      orders.order_id: "NOT NULL",
      inventory_items.id: "NOT NULL"
    ]
    sorts: [inventory_items_order_items_fields.total_gross_profit: desc]
    limit: 15
  }

  query: carbon_footprint_pants_miles_summary {
    description: "Carbon-Footprint Pants Miles summary of tracked shipments, total garment kilometers traveled, Earth equator laps equivalent, average shipment distance, and revenue per 1,000 kilometers flown."
    measures: [
      order_items.count,
      distribution_centers_order_items_users_fields.total_shipment_distance_km,
      distribution_centers_order_items_users_fields.earth_equator_laps_equivalent,
      distribution_centers_order_items_users_fields.avg_shipment_distance_km,
      distribution_centers_order_items_users_fields.revenue_per_1000_km_flown
    ]
    filters: [
      inventory_items.id: "NOT NULL",
      distribution_centers.id: "NOT NULL",
      users.id: "NOT NULL"
    ]
  }

  query: shipment_distance_by_origin_warehouse {
    description: "Shipped items, average shipment distance (km), and maximum shipment distance (km) broken down by origin fulfillment warehouse."
    dimensions: [distribution_centers.name]
    measures: [
      order_items.count,
      distribution_centers_order_items_users_fields.avg_shipment_distance_km,
      distribution_centers_order_items_users_fields.max_shipment_distance_km
    ]
    filters: [
      inventory_items.id: "NOT NULL",
      distribution_centers.id: "NOT NULL",
      users.id: "NOT NULL"
    ]
    sorts: [distribution_centers_order_items_users_fields.avg_shipment_distance_km: desc]
  }

  query: returns_by_fashion_guilt_sigma_tier {
    description: "Fashion Guilt Price-Outlier Return Elasticity breakdown of items bought, average price paid, average category baseline price, returned items, and item return rate across Fashion Guilt Sigma Tiers."
    dimensions: [category_sales_facts_order_items_fields.fashion_guilt_sigma_tier]
    measures: [
      order_items.count,
      order_items.avg_item_price,
      category_sales_facts_order_items_fields.avg_category_baseline,
      order_items.returned_items,
      order_items.return_rate
    ]
    filters: [
      products.id: "NOT NULL",
      products.category: "-NULL"
    ]
    sorts: [category_sales_facts_order_items_fields.fashion_guilt_sigma_tier: asc]
  }

  query: top_fashion_guilt_price_outliers {
    description: "Top 15 highest within-category Z-score purchased order items alongside product name, brand, sale price, category mean sold price, and item status."
    dimensions: [
      products.category,
      products.name,
      products.brand,
      order_items.sale_price,
      category_sales_facts.cat_mean_price,
      category_sales_facts_order_items_fields.price_z_score,
      order_items.status
    ]
    filters: [
      products.id: "NOT NULL",
      products.category: "-NULL"
    ]
    sorts: [category_sales_facts_order_items_fields.price_z_score: desc]
    limit: 15
  }

  query: spend_by_ip_nomad_tier {
    description: "Active buyers, items purchased, total revenue, and spend per buyer across IP Address Nomad Wanderlust Tiers."
    dimensions: [user_click_facts.ip_nomad_tier]
    measures: [
      order_items.distinct_users,
      order_items.count,
      order_items.total_revenue,
      order_items.spend_per_buyer
    ]
    filters: [user_click_facts.user_id: "NOT NULL"]
    sorts: [order_items.spend_per_buyer: desc]
  }

  query: revenue_by_product_title_word_count {
    description: "Product Naming Verbosity Tax breakdown of sold SKUs, units sold, average retail sticker price, total revenue, and sale price per title word by title word count."
    dimensions: [products.title_word_count]
    measures: [
      products.count,
      order_items.count,
      products.avg_sticker_price,
      order_items.total_revenue,
      order_items_products_fields.avg_price_per_title_word
    ]
    filters: [products.id: "NOT NULL"]
    sorts: [products.title_word_count: asc]
  }

  query: product_title_verbosity_price_correlations {
    description: "Pearson correlations between product title word count / character length and item sale price alongside maximum words in a sold product title."
    measures: [
      order_items_products_fields.title_word_count_price_correlation,
      order_items_products_fields.title_char_length_price_correlation,
      products.max_title_word_count
    ]
    filters: [products.id: "NOT NULL"]
  }

  query: top_multi_browser_combinations_by_revenue {
    description: "Top 15 multi-browser customer combinations (2+ browsers used) ranked by gross item revenue alongside buyer count and average item price."
    dimensions: [user_click_facts.browser_combo]
    measures: [
      order_items.distinct_users,
      order_items.total_revenue,
      order_items.avg_item_price
    ]
    filters: [user_click_facts.distinct_browsers_used: ">=2"]
    sorts: [order_items.total_revenue: desc]
    limit: 15
  }

  query: spend_by_customer_first_initial {
    description: "First-Name Vanity Spend Index grouping active buyers, items bought, total gross spend, and average item price by the starting letter of the customer's first name."
    dimensions: [users.first_initial]
    measures: [
      order_items.distinct_users,
      order_items.count,
      order_items.total_revenue,
      order_items.avg_item_price
    ]
    filters: [users.id: "NOT NULL"]
    sorts: [order_items.total_revenue: desc]
  }

  query: spend_by_full_name_letter_count {
    description: "Active buyers, average item sale price, and total gross revenue grouped by combined first-name and last-name character length."
    dimensions: [users.full_name_letter_count]
    measures: [
      order_items.distinct_users,
      order_items.avg_item_price,
      order_items.total_revenue
    ]
    filters: [users.id: "NOT NULL"]
    sorts: [users.full_name_letter_count: asc]
  }

  query: top_common_first_names_by_revenue {
    description: "Top 15 common customer first names (10+ distinct buyers) ranked by total gross revenue alongside distinct order volume."
    dimensions: [users.first_name]
    measures: [
      order_items.distinct_orders,
      order_items.total_revenue
    ]
    filters: [
      users.id: "NOT NULL",
      orders.order_id: "NOT NULL",
      order_items.distinct_users: ">=10"
    ]
    sorts: [order_items.total_revenue: desc]
    limit: 15
  }

  query: realized_gross_margin_summary {
    description: "Executive P&L summary comparing top-line gross revenue, wholesale inventory COGS, realized gross profit, and realized gross margin share."
    measures: [
      order_items.total_revenue,
      inventory_items_order_items_fields.total_cogs,
      inventory_items_order_items_fields.total_gross_profit,
      inventory_items_order_items_fields.gross_margin_ratio
    ]
    filters: [inventory_items.id: "NOT NULL"]
  }

  query: realized_gross_profit_by_inventory_department {
    description: "Units sold, realized department gross profit, and average unit gross profit broken down by physical inventory department."
    dimensions: [inventory_items.product_department]
    measures: [
      order_items.count,
      inventory_items_order_items_fields.total_gross_profit,
      inventory_items_order_items_fields.avg_gross_profit
    ]
    filters: [inventory_items.id: "NOT NULL"]
  }

  query: luxury_splurge_spend_by_life_stage {
    description: "Midlife Crisis Luxury Splurge Multiplier comparing distinct shoppers, items bought, average item price, $150+ high-ticket spend, and luxury spend share across life-stage age zones."
    dimensions: [users.life_stage_zone]
    measures: [
      order_items.distinct_users,
      order_items.count,
      order_items.avg_item_price,
      order_items_products_fields.total_luxury_150plus_revenue,
      order_items_products_fields.luxury_spend_share
    ]
    filters: [
      users.id: "NOT NULL",
      products.id: "NOT NULL"
    ]
    sorts: [users.life_stage_zone: asc]
  }

  query: oldest_skewing_categories_by_buyer_age {
    description: "Top 15 clothing department-category lines with the oldest average buyer profile alongside units sold, average paid item price, and average unit net margin."
    dimensions: [products.department, products.category]
    measures: [
      users.avg_customer_age,
      order_items.count,
      order_items.avg_item_price,
      inventory_items_order_items_fields.avg_gross_profit
    ]
    filters: [
      users.id: "NOT NULL",
      products.id: "NOT NULL",
      inventory_items.id: "NOT NULL"
    ]
    sorts: [users.avg_customer_age: desc]
    limit: 15
  }

  query: top_categories_by_recent_era_revenue_share {
    description: "Top 15 department-category lines ranked by 2025+ recent-era revenue momentum share alongside all-time revenue, recent-era revenue, and gross profit."
    dimensions: [products.department, products.category]
    measures: [
      order_items.total_revenue,
      order_items.recent_era_revenue,
      order_items.recent_era_revenue_share,
      inventory_items_order_items_fields.total_gross_profit
    ]
    filters: [
      products.id: "NOT NULL",
      inventory_items.id: "NOT NULL"
    ]
    sorts: [order_items.recent_era_revenue_share: desc]
    limit: 15
  }

  query: annual_department_sales_and_profit {
    description: "Annual units sold, gross revenue, and gross profit broken down by UTC calendar year and product department."
    dimensions: [order_items.created_year_utc, products.department]
    measures: [
      order_items.count,
      order_items.total_revenue,
      inventory_items_order_items_fields.total_gross_profit
    ]
    filters: [
      products.id: "NOT NULL",
      inventory_items.id: "NOT NULL"
    ]
    sorts: [
      order_items.created_year_utc: desc,
      products.department: asc
    ]
  }

  query: top_zero_return_unicorn_vips {
    description: "Top 15 high-spend ($250+) zero-return VIP customers ranked by net gross profit alongside items kept and gross spend."
    dimensions: [
      users.id,
      users.full_name,
      users.age,
      users.country
    ]
    measures: [
      order_items.count,
      order_items.total_revenue,
      inventory_items_order_items_fields.total_gross_profit
    ]
    filters: [
      users.id: "NOT NULL",
      inventory_items.id: "NOT NULL",
      order_items.returned_items: "0",
      order_items.total_revenue: ">=250"
    ]
    sorts: [inventory_items_order_items_fields.total_gross_profit: desc]
    limit: 15
  }

  query: order_items_by_full_stack_archetype {
    description: "Transaction item count, distinct buyers, average buyer age, gross revenue, retained net profit, average shipment distance, average shelf age, and average buyer clicks across Grand Unified Full-Stack Order-Line Archetypes."
    dimensions: [category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.order_line_archetype]
    measures: [
      order_items.count,
      order_items.distinct_users,
      users.avg_customer_age,
      order_items.total_revenue,
      inventory_items_order_items_fields.retained_net_profit,
      distribution_centers_order_items_users_fields.avg_shipment_distance_km,
      inventory_items_order_items_fields.avg_order_shelf_age_days,
      order_items_user_click_facts_fields.avg_item_buyer_clicks
    ]
    filters: [
      orders.order_id: "NOT NULL",
      users.id: "NOT NULL",
      products.id: "NOT NULL",
      inventory_items.id: "NOT NULL",
      distribution_centers.id: "NOT NULL"
    ]
    sorts: [category_sku_price_facts_distribution_centers_inventory_items_order_items_user_click_facts_user_item_volume_facts_user_warehouse_proximity_facts_fields.order_line_archetype: asc]
  }

  query: warehouse_department_routing_performance {
    description: "Outbound items shipped, completed items, gross profit margin, average days on shelf, and average shipment distance (km) by origin warehouse and product department."
    dimensions: [distribution_centers.name, products.department]
    measures: [
      order_items.count,
      order_items.completed_items,
      inventory_items_order_items_fields.total_gross_profit,
      inventory_items.avg_days_on_shelf,
      distribution_centers_order_items_users_fields.avg_shipment_distance_km
    ]
    filters: [
      orders.order_id: "NOT NULL",
      users.id: "NOT NULL",
      products.id: "NOT NULL",
      inventory_items.id: "NOT NULL",
      distribution_centers.id: "NOT NULL"
    ]
    sorts: [
      products.department: asc,
      inventory_items_order_items_fields.total_gross_profit: desc
    ]
  }

  query: top_country_browser_department_segments {
    description: "Top 20 country, latest customer browser, and product department segments ranked by net gross profit alongside active buyers, average buyer age, order count, and gross revenue."
    dimensions: [
      users.country,
      user_click_facts.latest_browser,
      products.department
    ]
    measures: [
      order_items.distinct_users,
      users.avg_customer_age,
      order_items.distinct_orders,
      order_items.total_revenue,
      inventory_items_order_items_fields.total_gross_profit
    ]
    filters: [
      users.id: "NOT NULL",
      orders.order_id: "NOT NULL",
      products.id: "NOT NULL",
      inventory_items.id: "NOT NULL",
      user_click_facts.user_id: "NOT NULL"
    ]
    sorts: [inventory_items_order_items_fields.total_gross_profit: desc]
    limit: 20
  }

  query: shipments_by_geospatial_haul_classification {
    description: "Shipped item count, average straight-line distance (km), and total gross profit across Supply-Chain Mismatched Detour versus Local Direct Item haul classifications."
    dimensions: [distribution_centers_order_items_users_fields.geospatial_haul_classification]
    measures: [
      order_items.count,
      distribution_centers_order_items_users_fields.avg_shipment_distance_km,
      inventory_items_order_items_fields.total_gross_profit
    ]
    filters: [
      inventory_items.id: "NOT NULL",
      products.id: "NOT NULL",
      distribution_centers.id: "NOT NULL",
      users.id: "NOT NULL"
    ]
    sorts: [distribution_centers_order_items_users_fields.geospatial_haul_classification: asc]
  }

  query: top_corridors_by_latitude_span {
    description: "Top 15 origin warehouse to destination country corridors ranked by average latitude degrees crossed alongside shipment volume."
    dimensions: [
      distribution_centers.name,
      users.country
    ]
    measures: [
      order_items.count,
      distribution_centers_order_items_users_fields.avg_lat_degrees_crossed
    ]
    filters: [
      inventory_items.id: "NOT NULL",
      distribution_centers.id: "NOT NULL",
      users.id: "NOT NULL"
    ]
    sorts: [distribution_centers_order_items_users_fields.avg_lat_degrees_crossed: desc]
    limit: 15
  }

  query: shipments_by_trade_corridor_regime {
    description: "Total shipments, origin warehouses used, average corridor distance (km), average doorstep delivery hours, gross revenue, and gross profit across Geospatial Fulfillment Corridor and Tariff Zone regimes."
    dimensions: [distribution_centers_order_items_users_fields.trade_corridor_regime]
    measures: [
      order_items.count,
      distribution_centers.count,
      distribution_centers_order_items_users_fields.avg_shipment_distance_km,
      order_items.avg_total_doorstep_wait_hours,
      order_items.total_revenue,
      inventory_items_order_items_fields.total_gross_profit
    ]
    filters: [
      orders.order_id: "NOT NULL",
      inventory_items.id: "NOT NULL",
      products.id: "NOT NULL",
      distribution_centers.id: "NOT NULL",
      users.id: "NOT NULL"
    ]
    sorts: [distribution_centers_order_items_users_fields.trade_corridor_regime: asc]
  }

  query: top_warehouse_country_corridors_by_profit {
    description: "Top 20 origin warehouse to destination country shipping lanes ranked by total gross profit alongside shipment volume and average distance (km)."
    dimensions: [
      distribution_centers.name,
      users.country
    ]
    measures: [
      order_items.count,
      distribution_centers_order_items_users_fields.avg_shipment_distance_km,
      inventory_items_order_items_fields.total_gross_profit
    ]
    filters: [
      inventory_items.id: "NOT NULL",
      distribution_centers.id: "NOT NULL",
      users.id: "NOT NULL"
    ]
    sorts: [inventory_items_order_items_fields.total_gross_profit: desc]
    limit: 20
  }

  query: top_monoculture_category_hoarder_baskets {
    description: "Top 15 multi-item monoculture orders (3+ units all within a single clothing category) ranked by basket units and gross basket spend."
    dimensions: [orders.order_id]
    measures: [
      order_items.count,
      order_items.total_revenue,
      order_items_products_fields.ordered_item_categories
    ]
    filters: [
      orders.order_id: "NOT NULL",
      products.id: "NOT NULL",
      order_items.count: ">=3",
      products.distinct_categories: "1"
    ]
    sorts: [
      order_items.count: desc,
      order_items.total_revenue: desc
    ]
    limit: 15
  }

  query: top_cross_department_postal_codes {
    description: "Top 15 high-volume cross-department postal codes (at least 5 Menswear units and 5 Womenswear units sold) ranked by total gross spend."
    dimensions: [
      users.postal_code,
      users.city,
      users.country
    ]
    measures: [
      users.count,
      order_items_products_fields.mens_units,
      order_items_products_fields.womens_units,
      order_items.total_revenue
    ]
    filters: [
      users.id: "NOT NULL",
      products.id: "NOT NULL",
      order_items_products_fields.mens_units: ">=5",
      order_items_products_fields.womens_units: ">=5"
    ]
    sorts: [order_items.total_revenue: desc]
    limit: 15
  }

  query: top_profit_angel_customers {
    description: "Top 15 multi-item customers (3+ items bought) ranked by blended gross profit margin and net dollar profit."
    dimensions: [
      users.id,
      users.full_name,
      users.age
    ]
    measures: [
      order_items.count,
      order_items.total_revenue,
      inventory_items_order_items_fields.total_gross_profit,
      inventory_items_order_items_fields.gross_margin_ratio
    ]
    filters: [
      users.id: "NOT NULL",
      inventory_items.id: "NOT NULL",
      order_items.count: ">=3"
    ]
    sorts: [
      inventory_items_order_items_fields.gross_margin_ratio: desc,
      inventory_items_order_items_fields.total_gross_profit: desc
    ]
    limit: 15
  }

  query: socks_and_hosiery_obsession_index {
    description: "Socks and Hosiery Obsession Index calculates what percentage of all units sold and total store revenue comes specifically from customers buying socks and hosiery across men's and women's lines."
    measures: [
      order_items_products_fields.sock_units_sold,
      order_items.count,
      order_items_products_fields.sock_unit_share,
      order_items_products_fields.total_sock_revenue,
      order_items_products_fields.sock_revenue_share
    ]
  }

  query: socks_and_hosiery_sales_by_category_and_department {
    description: "Units sold and gross revenue for Socks and Socks & Hosiery broken down by product category and department."
    dimensions: [products.category, products.department]
    measures: [
      order_items.count,
      order_items.total_revenue
    ]
    filters: [products.category: "Socks,Socks & Hosiery"]
    sorts: [order_items.total_revenue: desc]
  }

  query: brand_return_boomerang_leaderboard {
    description: "Brand Return Boomerang Rate leaderboard showing total items ordered, boomeranged items, boomerang return rate, and refunded dollars by brand for brands with at least 30 ordered items."
    dimensions: [products.brand]
    measures: [
      order_items.count,
      order_items.ever_returned_items,
      order_items.ever_return_rate,
      order_items.refunded_revenue
    ]
    filters: [
      orders.order_id: "NOT NULL",
      products.id: "NOT NULL",
      order_items.count: ">=30"
    ]
    sorts: [order_items.ever_return_rate: desc]
    limit: 20
  }

  query: category_return_rate_leaderboard {
    description: "Clothing categories ranked by customer item return rate, showing items ordered, items returned, and return rate."
    dimensions: [products.category]
    measures: [
      order_items.count,
      order_items.returned_items,
      order_items.return_rate
    ]
    filters: [products.id: "NOT NULL"]
    sorts: [order_items.return_rate: desc]
    limit: 15
  }

  query: warm_clothing_spend_by_thermal_zone {
    description: "Hemisphere and Latitude Fashion Chill Factor compares item volume, cozy warm clothing spend, total spend, and warm clothing spend share across customer latitude thermal zones."
    dimensions: [users.thermal_zone]
    measures: [
      order_items.count,
      order_items_products_fields.total_warm_clothing_revenue,
      order_items.total_revenue,
      order_items_products_fields.warm_clothing_revenue_share
    ]
    filters: [
      users.id: "NOT NULL",
      products.id: "NOT NULL"
    ]
    sorts: [users.thermal_zone: asc]
  }

  query: latitude_and_age_price_correlations {
    description: "Pearson correlations between customer absolute latitude or age and ordered item sale price, alongside average absolute customer latitude."
    measures: [
      order_items_users_fields.latitude_price_correlation,
      order_items_users_fields.age_price_correlation,
      users.avg_abs_latitude
    ]
    filters: [users.id: "NOT NULL"]
  }

  query: spend_by_shopper_gender_and_department {
    description: "Items bought, total spend, and average item price broken down by shopper gender and product department."
    dimensions: [users.gender, products.department]
    measures: [
      order_items.count,
      order_items.total_revenue,
      order_items.avg_item_price
    ]
    filters: [
      users.id: "NOT NULL",
      products.id: "NOT NULL"
    ]
    sorts: [
      users.gender: asc,
      products.department: asc
    ]
  }

  query: gender_cross_shopping_index {
    description: "Gender-Bending Wardrobe Cross-Shopping Index tracking cross-department gift items, total items sold, and cross-department purchasing rate across male and female shoppers."
    measures: [
      order_items_products_users_fields.cross_department_gift_items,
      order_items.count,
      order_items_products_users_fields.cross_shopping_rate
    ]
    filters: [
      users.id: "NOT NULL",
      orders.order_id: "NOT NULL",
      products.id: "NOT NULL"
    ]
  }

  query: high_roller_single_items {
    description: "High-Roller Single Item identifies any individual order item sold for a hundred dollars or more. Merchandising and fulfillment teams use this label to spot premium-ticket purchases that qualify for upgraded packaging and VIP post-purchase follow-up."
    dimensions: [
      order_items.id,
      order_items.order_id,
      order_items.user_id,
      order_items.product_id,
      order_items.status,
      order_items.sale_price
    ]
    filters: [order_items.is_high_roller_single_item: "yes"]
    sorts: [order_items.sale_price: desc]
    limit: 25
  }

  query: fulfillment_speed_tiers {
    description: "Order item volume and average item sale price across Flash-Flood versus Snail-Mail Fulfillment Tiers."
    dimensions: [order_items.fulfillment_speed_tier]
    measures: [
      order_items.count,
      order_items.avg_item_price
    ]
    sorts: [order_items.fulfillment_speed_tier: asc]
  }

  query: longest_doorstep_wait_items {
    description: "Top 15 delivered order items with the longest total doorstep wait time in hours, showing warehouse processing hours, carrier transit hours, and total hours."
    dimensions: [
      order_items.id,
      order_items.order_id,
      order_items.status,
      order_items.hours_to_ship,
      order_items.hours_to_deliver,
      order_items.hours_total_doorstep_wait
    ]
    filters: [order_items.is_delivered: "yes"]
    sorts: [order_items.hours_total_doorstep_wait: desc]
    limit: 15
  }

  query: sales_by_retail_seasonal_vintage {
    description: "Order count, items sold, seasonal gross revenue, and average item price across Retail Seasonal Order Vintage fashion seasons."
    dimensions: [order_items.retail_seasonal_vintage]
    measures: [
      orders.count,
      order_items.count,
      order_items.total_revenue,
      order_items.avg_item_price
    ]
    filters: [
      orders.order_id: "NOT NULL",
      products.id: "NOT NULL"
    ]
    sorts: [order_items.retail_seasonal_vintage: asc]
  }

  query: monthly_seasonal_category_units {
    description: "Calendar month breakdown of Activewear, Swimwear, and Sweaters & Outerwear units sold alongside total monthly revenue."
    dimensions: [order_items.created_month_num]
    measures: [
      order_items_products_fields.activewear_units,
      order_items_products_fields.swimwear_units,
      order_items_products_fields.winter_cozy_units,
      order_items.total_revenue
    ]
    filters: [products.id: "NOT NULL"]
    sorts: [order_items.created_month_num: asc]
  }
}
