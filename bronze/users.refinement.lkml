include: "users.view.lkml"

view: +users {
  dimension: cohort_signup_year {
    label: "Cohort Signup Year"
    group_label: "Created Date"
    description: "Calendar year (UTC) in which the customer first signed up."
    synonyms: ["signup year", "customer vintage year", "registration year"]
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
