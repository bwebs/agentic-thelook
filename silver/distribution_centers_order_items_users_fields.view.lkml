view: distribution_centers_order_items_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${order_items.id} ;;
  }

  dimension: lat_degrees_crossed {
    label: "Latitude Degrees Crossed"
    group_label: "Geospatial Freight & Corridors"
    description: "Absolute north-south latitude span (in degrees) crossed between the origin fulfillment warehouse and the customer's destination coordinates."
    synonyms: ["latitude span degrees", "shipment latitude degrees crossed"]
    type: number
    value_format_name: decimal_2
    sql: ABS(${distribution_centers.latitude} - ${users.latitude}) ;;
  }

  dimension: lon_degrees_crossed {
    label: "Longitude Degrees Crossed"
    group_label: "Geospatial Freight & Corridors"
    description: "Absolute east-west longitude span (in degrees) crossed between the origin fulfillment warehouse and the customer's destination coordinates."
    synonyms: ["longitude span degrees", "shipment longitude degrees crossed"]
    type: number
    value_format_name: decimal_2
    sql: ABS(${distribution_centers.longitude} - ${users.longitude}) ;;
  }

  dimension: shipment_distance_km {
    label: "Shipment Straight-Line Distance (km)"
    group_label: "Geospatial Freight & Corridors"
    description: "Straight-line geodesic distance in kilometers between the origin distribution center and the customer's home coordinates (ST_DISTANCE / 1000)."
    synonyms: ["flight km", "corridor km", "shipment distance km", "freight distance km"]
    type: number
    value_format_name: decimal_1
    sql: ST_DISTANCE(${distribution_centers.distribution_center_geom}, ${users.user_geom}) / 1000.0 ;;
  }

  dimension: geospatial_haul_classification {
    label: "Supply-Chain Mismatched Detour versus Local Direct Item"
    group_label: "Geospatial Freight & Corridors"
    description: "Supply-Chain Mismatched Detour versus Local Direct Item classifies every shipped item by how many degrees of latitude and longitude it crossed between the origin warehouse and the customer's doorstep: Local Regional Hops (<5 deg Lat & <10 deg Lon), Cross-Zone Continental Hauls (<15 deg Lat & <40 deg Lon), and Trans-Oceanic / Trans-Latitudinal Expeditions. Logistics and sustainability teams use this haul classification to track long-distance freight exposure across warehouse-to-country corridors."
    synonyms: [
      "geospatial haul classification",
      "supply-chain mismatched detour vs local direct item",
      "mismatched detour versus local direct item",
      "haul classification"
    ]
    case: {
      when: {
        sql: ${lat_degrees_crossed} < 5.0 AND ${lon_degrees_crossed} < 10.0 ;;
        label: "Local Regional Hop (<5 deg Lat & <10 deg Lon)"
      }
      when: {
        sql: ${lat_degrees_crossed} < 15.0 AND ${lon_degrees_crossed} < 40.0 ;;
        label: "Cross-Zone Continental Haul"
      }
      else: "Trans-Oceanic / Trans-Latitudinal Expedition"
    }
  }

  dimension: trade_corridor_regime {
    label: "Geospatial Fulfillment Corridor and Tariff Zone"
    group_label: "Geospatial Freight & Corridors"
    description: "Geospatial Fulfillment Corridor and Tariff Zone classifies every shipment by origin warehouse, destination country, and travel distance into five logistics regimes: Domestic Short-Haul Trucking (<800 km US), Domestic Transcontinental Rail/Air (800+ km US), Transatlantic European Cargo, Transpacific Asia-Oceania Air-Freight, and Pan-American Southbound Corridors. International trade and freight managers use these corridor classifications to benchmark delivery times and net profit across global shipping lanes."
    synonyms: [
      "trade corridor regime",
      "geospatial fulfillment corridor and tariff zone",
      "fulfillment corridor",
      "tariff zone",
      "shipping corridor regime"
    ]
    case: {
      when: {
        sql: ${users.country} = 'United States' AND ${shipment_distance_km} < 800.0 ;;
        label: "Domestic Short-Haul Trucking Corridor (<800 km US)"
      }
      when: {
        sql: ${users.country} = 'United States' ;;
        label: "Domestic Transcontinental Rail/Air Corridor (800+ km US)"
      }
      when: {
        sql: ${users.country} IN ('United Kingdom', 'France', 'Germany', 'Spain', 'Belgium', 'Poland') ;;
        label: "Transatlantic European Cargo Corridor"
      }
      when: {
        sql: ${users.country} IN ('China', 'Japan', 'South Korea', 'Australia') ;;
        label: "Transpacific Asia-Oceania Air-Freight Corridor"
      }
      else: "Pan-American Southbound Corridor (Brasil & Colombia)"
    }
  }

  measure: avg_shipment_distance_km {
    label: "Average Shipment Distance (km)"
    description: "Average straight-line geodesic distance in kilometers traveled per shipment from origin warehouse to customer destination."
    synonyms: ["avg flight km", "avg corridor distance km", "average corridor distance km", "avg km"]
    type: average
    tags: ["non_additive"]
    value_format_name: decimal_1
    sql: ${shipment_distance_km} ;;
  }

  measure: avg_lat_degrees_crossed {
    label: "Average Latitude Degrees Crossed"
    description: "Average north-south latitude span (in degrees) crossed per shipment between origin warehouse and customer destination."
    synonyms: ["avg latitude degrees crossed", "average latitude span"]
    type: average
    tags: ["non_additive"]
    value_format_name: decimal_2
    sql: ${lat_degrees_crossed} ;;
  }

  measure: total_shipment_distance_km {
    label: "Carbon-Footprint Pants Miles (Total Garment km)"
    description: "Carbon-Footprint Pants Miles calculates the cumulative real-world geographic distance in kilometers that shipped garments travel from their origin warehouse to the customer's home address. Sustainability and logistics teams use this mileage metric to estimate shipping emissions and evaluate regional fulfillment reach."
    synonyms: ["total garment kilometers traveled", "carbon-footprint pants miles", "total shipment distance km", "garment kilometers traveled"]
    type: sum
    value_format_name: decimal_0
    sql: ${shipment_distance_km} ;;
  }

  measure: earth_equator_laps_equivalent {
    label: "Earth Equator Laps Equivalent"
    description: "Cumulative garment shipping kilometers divided by Earth's equatorial circumference (40,075 km), expressing total shipment mileage in equator laps."
    synonyms: ["earth equator laps equivalent", "earth equator laps", "equator laps flown"]
    tags: ["non_additive"]
    type: number
    value_format_name: decimal_1
    sql: ${total_shipment_distance_km} / 40075.0 ;;
  }

  measure: revenue_per_1000_km_flown {
    label: "Revenue per 1,000 km Flown"
    description: "Gross dollar sales generated per thousand kilometers of garment shipping distance (1000 * total_revenue / total_shipment_distance_km)."
    synonyms: ["revenue per 1000 km flown", "revenue per thousand kilometers", "dollars per 1000 km"]
    tags: ["non_additive"]
    type: number
    value_format_name: decimal_4
    sql: 1000.0 * ${order_items.total_revenue} / NULLIF(${total_shipment_distance_km}, 0) ;;
  }

  measure: max_shipment_distance_km {
    label: "Maximum Shipment Distance (km)"
    description: "Longest straight-line geodesic distance in kilometers traveled by a single shipped item from origin warehouse to customer destination."
    synonyms: ["max distance km", "max shipment distance km", "maximum flight distance km"]
    tags: ["non_additive"]
    type: max
    value_format_name: decimal_2
    sql: ${shipment_distance_km} ;;
  }
}
