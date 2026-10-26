include: "users.view.lkml"

view: +users {
  dimension_group: created {
    description: "Timestamp when the shopper created their store account. New Customer status is determined by created_year: filter created_year to 'this year' (or a target calendar year) on Users, or compare orders.created_year, order_items.created_year, or events.created_year to users.created_year in other explores."
    synonyms: ["account creation", "customer signup", "new customer signup"]
  }

  dimension: cohort_signup_year {
    label: "Cohort Signup Year"
    group_label: "Created Date"
    description: "Calendar year (UTC) in which the customer first signed up. Determines New Customer status: filter to the current or target calendar year on Users, or compare orders.created_year, order_items.created_year, or events.created_year to cohort_signup_year (or years_since_signup = 0) in other explores."
    synonyms: ["signup year", "customer vintage year", "registration year", "account creation year"]
    type: number
    value_format_name: id
    sql: EXTRACT(YEAR FROM ${created_raw}) ;;
  }

  dimension: abs_latitude {
    label: "Absolute Latitude"
    description: "Absolute degrees of latitude from the equator (0 to 90 degrees), measuring how far north or south a customer lives from tropical latitudes."
    synonyms: ["absolute customer latitude", "distance from equator"]
    type: number
    sql: ABS(${latitude}) ;;
    value_format_name: decimal_2
  }

  dimension: thermal_zone {
    label: "Thermal Zone"
    description: "Geographic climate latitude band grouping customers by absolute distance from the equator into '1. High Latitude Frost Zone (45+ deg)', '2. Temperate Sweater Belt (30-45 deg)', and '3. Tropical Flip-Flop Zone (<30 deg)'."
    synonyms: ["climate zone", "latitude thermal zone", "hemisphere climate split"]
    type: string
    sql: CASE
      WHEN ${abs_latitude} >= 45 THEN '1. High Latitude Frost Zone (45+ deg)'
      WHEN ${abs_latitude} >= 30 THEN '2. Temperate Sweater Belt (30-45 deg)'
      ELSE '3. Tropical Flip-Flop Zone (<30 deg)'
    END ;;
  }

  dimension: is_young_customer {
    label: "Young Customer"
    description: "Young Customer defines any registered shopper under the age of 25, covering our teen and early-twenties audience. Youth marketing teams use this segment to target student discount codes, campus promos, and streetwear campaigns."
    synonyms: ["is young customer", "young customers", "under 25", "teen and early-twenties audience", "youth segment"]
    type: yesno
    sql: ${age} < 25 ;;
  }

  dimension: thoroughfare_tier {
    label: "Street Address Thoroughfare Aristocracy Tier"
    description: "Street Address Thoroughfare Aristocracy Tier groups customers by the kind of road named in their home street address, separating grand boulevards and avenues from quiet cul-de-sac courts, standard streets and roads, and international lanes. Direct-mail marketers use this playful neighborhood taxonomy to slice regional catalog mailings."
    synonyms: ["thoroughfare aristocracy tier", "street address tier", "road type tier", "neighborhood taxonomy"]
    type: string
    sql: CASE
      WHEN REGEXP_CONTAINS(LOWER(${street_address}), r'(boulevard|blvd|avenue|ave|parkway|pkwy)') THEN '1. Boulevard & Avenue Flaneur'
      WHEN REGEXP_CONTAINS(LOWER(${street_address}), r'(court|ct|place|pl|circle|cir|terrace|way)') THEN '2. Cul-de-Sac Court Royalty'
      WHEN REGEXP_CONTAINS(LOWER(${street_address}), r'(street|st|road|rd|drive|dr)') THEN '3. Standard Street & Road Citizen'
      ELSE '4. Mystery Lane / International Address'
    END ;;
  }

  dimension: hemisphere_belt {
    label: "Hemisphere and Equator Proximity Belt"
    description: "Hemisphere and Equator Proximity Belt segments our global customer base by north-south latitude into '1. Northern High-Latitude Frost Belt (>=50N)', '2. Northern Temperate Fashion Zone (23.5N to 50N)', '3. Equatorial Tropics (-23.5S to 23.5N)', and '4. Southern Hemisphere Down-Under (<-23.5S)'. Regional merchandising teams use this geographic belt to swap winter coat banners and summer swimwear promotions between northern and southern hemisphere shoppers."
    synonyms: ["hemisphere and equator proximity belt", "equator proximity belt", "latitude belt", "hemisphere zone"]
    type: string
    sql: CASE
      WHEN ${latitude} >= 50.0 THEN '1. Northern High-Latitude Frost Belt (>=50N)'
      WHEN ${latitude} >= 23.5 THEN '2. Northern Temperate Fashion Zone (23.5N to 50N)'
      WHEN ${latitude} >= -23.5 THEN '3. Equatorial Tropics (-23.5S to 23.5N)'
      ELSE '4. Southern Hemisphere Down-Under (<-23.5S)'
    END ;;
  }

  dimension: longitude_sector {
    label: "Longitude Sector"
    description: "East-west geographic longitude sector grouping customers into 'Americas West' (< -30.0 deg), 'Europe/Africa Prime' (-30.0 to < 60.0 deg), and 'Asia/Oceania East' (>= 60.0 deg) for regional merchandising analysis."
    synonyms: ["east-west longitude sector", "longitude region", "global longitude band"]
    type: string
    sql: CASE
      WHEN ${longitude} < -30.0 THEN 'Americas West'
      WHEN ${longitude} < 60.0 THEN 'Europe/Africa Prime'
      ELSE 'Asia/Oceania East'
    END ;;
  }

  measure: count {
    description: "Total number of registered shopper accounts."
    synonyms: ["registered users", "registered customers", "total users"]
  }

  measure: avg_customer_age {
    label: "Average Customer Wisdom Level"
    description: "Average Customer Wisdom Level measures the mean age of our registered shopper base alongside the youngest and oldest customers on file. The social media marketing team checks this demographic pulse to decide how much creative budget goes toward youth channels versus older audiences."
    synonyms: ["average shopper age", "avg user age"]
    type: average
    sql: ${age} ;;
    value_format_name: decimal_2
  }

  measure: youngest_shopper_age {
    label: "Youngest Shopper Age"
    description: "Minimum age of our registered shopper base on file."
    type: min
    sql: ${age} ;;
  }

  measure: oldest_shopper_age {
    label: "Oldest Shopper Age"
    description: "Maximum age of our registered shopper base on file."
    type: max
    sql: ${age} ;;
  }

  measure: avg_abs_latitude {
    label: "Average Absolute Customer Latitude"
    description: "Mean absolute distance from the equator (in degrees of latitude) across distinct customers."
    synonyms: ["avg abs customer latitude", "average absolute latitude"]
    type: average
    sql: ${abs_latitude} ;;
    value_format_name: decimal_2
  }
}
