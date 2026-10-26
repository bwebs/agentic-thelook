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

  dimension: age_bucket {
    label: "Generational Age Bucket"
    description: "Generational Age Buckets group shoppers into four life-stage cohorts: '1. Teen & Gen-Z (<25)', '2. Millennial Hustler (25-39)', '3. Gen-X Boss (40-54)', and '4. Boomer & Golden Senior (55+)'. Marketing and merchandising teams use these groupings to compare conversion rates, return habits, and clothing preferences across generations."
    synonyms: ["generational age buckets", "generational cohort", "life-stage cohort", "age generation"]
    type: string
    sql: CASE
      WHEN ${age} < 25 THEN '1. Teen & Gen-Z (<25)'
      WHEN ${age} BETWEEN 25 AND 39 THEN '2. Millennial Hustler (25-39)'
      WHEN ${age} BETWEEN 40 AND 54 THEN '3. Gen-X Boss (40-54)'
      ELSE '4. Boomer & Golden Senior (55+)'
    END ;;
  }

  dimension: age_decade {
    label: "Age Decade"
    description: "Ten-year age decade floor (e.g., 10, 20, 30) grouping shoppers into ten-year demographic brackets."
    synonyms: ["age decade floor", "ten-year age decade", "decade of age"]
    type: number
    value_format_name: decimal_0
    sql: CAST(FLOOR(${age} / 10) * 10 AS INT64) ;;
  }

  dimension: age_decade_label {
    label: "Age Decade Label"
    description: "Formatted ten-year age decade label (e.g., '20s Decade', '30s Decade') for generational cohort reporting."
    synonyms: ["decade label", "age decade cohort"]
    type: string
    sql: CONCAT(CAST(${age_decade} AS STRING), 's Decade') ;;
  }

  dimension: global_macro_region {
    label: "Global Macro Region"
    description: "Global Macro Regions roll individual countries up into broad commercial territories: '1. North America', '2. European Runway', '3. Asia-Pacific Tigers', '4. Latin America Fiesta', and '5. Rest of Galaxy'. Regional sales directors use these territory definitions to manage regional performance targets and localized shipping policies."
    synonyms: ["global macro regions", "commercial territory", "macro region", "international sales region"]
    type: string
    sql: CASE
      WHEN ${country} IN ('United States') THEN '1. North America'
      WHEN ${country} IN ('United Kingdom', 'France', 'Germany', 'Spain', 'Belgium', 'Poland') THEN '2. European Runway'
      WHEN ${country} IN ('China', 'Japan', 'South Korea', 'Australia') THEN '3. Asia-Pacific Tigers'
      WHEN ${country} IN ('Brasil', 'Colombia') THEN '4. Latin America Fiesta'
      ELSE '5. Rest of Galaxy'
    END ;;
  }

  dimension: us_super_region {
    label: "US Super-Region"
    description: "US Super-Regions roll domestic states up into four US commercial zones: 'US West Coast & Pacific', 'US Sunbelt & South', 'US Northeast Corridor', and 'US Heartland & Midwest' (filter country to 'United States' when analyzing domestic shoppers)."
    synonyms: ["us super-regions", "us super region", "us state region", "domestic sales zone"]
    type: string
    sql: CASE
      WHEN ${state} IN ('California', 'Oregon', 'Washington', 'Nevada', 'Arizona', 'Hawaii', 'Alaska') THEN 'US West Coast & Pacific'
      WHEN ${state} IN ('Texas', 'Florida', 'Georgia', 'North Carolina', 'Virginia', 'Tennessee', 'Louisiana', 'Alabama', 'South Carolina') THEN 'US Sunbelt & South'
      WHEN ${state} IN ('New York', 'Pennsylvania', 'New Jersey', 'Massachusetts', 'Connecticut', 'Maryland') THEN 'US Northeast Corridor'
      ELSE 'US Heartland & Midwest'
    END ;;
  }

  dimension: postal_code_zone {
    label: "Postal Code First-Digit Zone"
    description: "Leading character of the shopper's postal code (first-digit ZIP zone for United States addresses) used for regional shipping and territory rollups."
    synonyms: ["zip first digit zone", "postal code prefix", "us zip zone"]
    type: string
    sql: SUBSTR(${postal_code}, 1, 1) ;;
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

  dimension: postal_code_parity {
    label: "Zip Code Numeric Parity Tribe"
    description: "Zip Code Numeric Parity Tribe divides customers into 'Even-Zip Aristocrat', 'Odd-Zip Rebel', and 'Alphanumeric International Postcode' based on whether their postal code is an even number, an odd number, or contains letters or non-digits. Growth analysts use even-versus-odd postal codes as a simple geographic holdout split when testing regional marketing campaigns."
    synonyms: ["zip code numeric parity tribe", "zip parity tribe", "postal code numeric parity", "even odd zip holdout"]
    type: string
    sql: CASE
      WHEN REGEXP_CONTAINS(${postal_code}, r'^[0-9]+$') AND MOD(SAFE_CAST(${postal_code} AS INT64), 2) = 0 THEN 'Even-Zip Aristocrat'
      WHEN REGEXP_CONTAINS(${postal_code}, r'^[0-9]+$') AND MOD(SAFE_CAST(${postal_code} AS INT64), 2) = 1 THEN 'Odd-Zip Rebel'
      ELSE 'Alphanumeric International Postcode'
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

  measure: distinct_countries {
    label: "Distinct Countries"
    description: "Count of distinct countries represented across registered shopper accounts."
    synonyms: ["countries represented", "country count", "unique countries"]
    type: count_distinct
    sql: ${country} ;;
    tags: ["non_additive"]
  }
}
