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

  dimension: age {
    group_label: "Age"
  }

  dimension: is_young_customer {
    label: "Young Customer"
    group_label: "Age"
    description: "Young Customer defines any registered shopper under the age of 25, covering our teen and early-twenties audience. Youth marketing teams use this segment to target student discount codes, campus promos, and streetwear campaigns."
    synonyms: ["is young customer", "young customers", "under 25", "teen and early-twenties audience", "youth segment"]
    type: yesno
    sql: ${age} < 25 ;;
  }

  dimension: age_bucket {
    label: "Generational Age Bucket"
    group_label: "Age"
    description: "Generational Age Buckets group shoppers into four life-stage cohorts: 'Teen & Gen-Z (<25)', 'Millennial Hustler (25-39)', 'Gen-X Boss (40-54)', and 'Boomer & Golden Senior (55+)'. Marketing and merchandising teams use these groupings to compare conversion rates, return habits, and clothing preferences across generations."
    synonyms: ["generational age buckets", "generational cohort", "life-stage cohort", "age generation"]
    case: {
      when: {
        sql: ${age} < 25 ;;
        label: "Teen & Gen-Z (<25)"
      }
      when: {
        sql: ${age} BETWEEN 25 AND 39 ;;
        label: "Millennial Hustler (25-39)"
      }
      when: {
        sql: ${age} BETWEEN 40 AND 54 ;;
        label: "Gen-X Boss (40-54)"
      }
      else: "Boomer & Golden Senior (55+)"
    }
  }

  dimension: age_decade {
    label: "Age Decade"
    group_label: "Age"
    description: "Ten-year age decade floor (e.g., 10, 20, 30) grouping shoppers into ten-year demographic brackets."
    synonyms: ["age decade floor", "ten-year age decade", "decade of age"]
    type: number
    value_format_name: decimal_0
    sql: CAST(FLOOR(${age} / 10) * 10 AS INT64) ;;
  }

  dimension: age_decade_label {
    label: "Age Decade Label"
    group_label: "Age"
    description: "Formatted ten-year age decade label (e.g., '20s Decade', '30s Decade') for generational cohort reporting."
    synonyms: ["decade label", "age decade cohort"]
    type: string
    sql: CONCAT(CAST(${age_decade} AS STRING), 's Decade') ;;
  }

  dimension: global_macro_region {
    label: "Global Macro Region"
    group_label: "Location"
    description: "Global Macro Regions roll individual countries up into broad commercial territories: 'North America', 'European Runway', 'Asia-Pacific Tigers', 'Latin America Fiesta', and 'Rest of Galaxy'. Regional sales directors use these territory definitions to manage regional performance targets and localized shipping policies."
    synonyms: ["global macro regions", "commercial territory", "macro region", "international sales region"]
    case: {
      when: {
        sql: ${country} IN ('United States') ;;
        label: "North America"
      }
      when: {
        sql: ${country} IN ('United Kingdom', 'France', 'Germany', 'Spain', 'Belgium', 'Poland') ;;
        label: "European Runway"
      }
      when: {
        sql: ${country} IN ('China', 'Japan', 'South Korea', 'Australia') ;;
        label: "Asia-Pacific Tigers"
      }
      when: {
        sql: ${country} IN ('Brasil', 'Colombia') ;;
        label: "Latin America Fiesta"
      }
      else: "Rest of Galaxy"
    }
  }

  dimension: us_super_region {
    label: "US Super-Region"
    group_label: "Location"
    description: "US Super-Regions roll domestic United States addresses up into four commercial zones: 'US West Coast & Pacific', 'US Sunbelt & South', 'US Northeast Corridor', and 'US Heartland & Midwest' (returns NULL for shoppers outside the United States)."
    synonyms: ["us super-regions", "us super region", "us state region", "domestic sales zone"]
    case: {
      when: {
        sql: ${country} = 'United States' AND ${state} IN ('California', 'Oregon', 'Washington', 'Nevada', 'Arizona', 'Hawaii', 'Alaska') ;;
        label: "US West Coast & Pacific"
      }
      when: {
        sql: ${country} = 'United States' AND ${state} IN ('Texas', 'Florida', 'Georgia', 'North Carolina', 'Virginia', 'Tennessee', 'Louisiana', 'Alabama', 'South Carolina') ;;
        label: "US Sunbelt & South"
      }
      when: {
        sql: ${country} = 'United States' AND ${state} IN ('New York', 'Pennsylvania', 'New Jersey', 'Massachusetts', 'Connecticut', 'Maryland') ;;
        label: "US Northeast Corridor"
      }
      when: {
        sql: ${country} = 'United States' ;;
        label: "US Heartland & Midwest"
      }
    }
  }

  dimension: postal_code_zone {
    label: "US Postal Code First-Digit Zone"
    group_label: "Location"
    description: "First-digit US ZIP code zone (0-9) for United States addresses used for regional shipping and territory rollups (returns NULL for shoppers outside the United States)."
    synonyms: ["zip first digit zone", "postal code prefix", "us zip zone"]
    type: string
    sql: CASE WHEN ${country} = 'United States' THEN SUBSTR(${postal_code}, 1, 1) END ;;
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

  dimension: first_name {
    group_label: "Name"
  }

  dimension: last_name {
    group_label: "Name"
  }

  dimension: is_alliterative_name {
    label: "Alliterative Name"
    group_label: "Name"
    description: "Whether the customer's first and last names share the exact same uppercase starting initial."
    synonyms: ["is alliterative name", "matching initials", "same first and last initial"]
    type: yesno
    sql: SUBSTR(UPPER(${first_name}), 1, 1) = SUBSTR(UPPER(${last_name}), 1, 1) ;;
  }

  dimension: name_phonetics_club {
    label: "Alliterative and Geminate Name VIP Club"
    group_label: "Name"
    description: "Alliterative and Geminate Name VIP Club classifies customers by phonetic patterns in their names into 'Marvel Superhero Alliterative Name (Same Initials)', 'Double-Letter Geminate Name Club', and 'Regular Non-Alliterative Civilian'. Creative marketing teams use this segment for novelty name-day promotions and monogrammed apparel campaigns."
    synonyms: ["name phonetics club", "alliterative and geminate name vip club", "phonetic name segment", "name vip club"]
    case: {
      when: {
        sql: ${is_alliterative_name} ;;
        label: "Marvel Superhero Alliterative Name (Same Initials)"
      }
      when: {
        sql: REGEXP_CONTAINS(LOWER(CONCAT(${first_name}, ${last_name})), r'(aa|ee|ll|oo|ss|tt|nn|mm|rr)') ;;
        label: "Double-Letter Geminate Name Club"
      }
      else: "Regular Non-Alliterative Civilian"
    }
  }

  dimension: monogram {
    label: "Name Monogram"
    group_label: "Name"
    description: "Two-initial customer monogram formatted with trailing periods (e.g., 'P.P.') from first_name and last_name."
    synonyms: ["monogram", "customer initials", "initial monogram"]
    type: string
    sql: CONCAT(SUBSTR(${first_name}, 1, 1), '.', SUBSTR(${last_name}, 1, 1), '.') ;;
  }

  dimension: full_name {
    label: "Full Name"
    group_label: "Name"
    description: "Customer full name combining first_name and last_name separated by a space."
    synonyms: ["customer name", "whale name", "shopper full name"]
    type: string
    sql: CONCAT(${first_name}, ' ', ${last_name}) ;;
  }

  dimension: name_tokens {
    hidden: yes
    description: "Two-element array [first_name, last_name] for unnested given-name and surname token analysis."
    sql: [${first_name}, ${last_name}] ;;
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
