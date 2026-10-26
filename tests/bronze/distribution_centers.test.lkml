include: "../../bronze/explores/distribution_centers.explore.lkml"

test: distribution_centers_refinement_metrics {
  explore_source: distribution_centers {
    column: total_warehouses { field: distribution_centers.count }
    column: mean_warehouse_latitude { field: distribution_centers.mean_warehouse_latitude }
    filters: {
      field: distribution_centers.id
      value: "1"
    }
  }
  assert: total_warehouses_matches {
    expression: ${distribution_centers.count} = 1 ;;
  }
  assert: mean_warehouse_latitude_matches {
    expression: round(${distribution_centers.mean_warehouse_latitude}, 4) = 35.1174 ;;
  }
}

test: distribution_centers_id_le_10_logistics_belt {
  explore_source: distribution_centers {
    column: logistics_belt { field: distribution_centers.logistics_belt }
    column: count { field: distribution_centers.count }
    filters: [distribution_centers.id: "<=10"]
    sorts: [distribution_centers.logistics_belt: asc]
  }
  assert: logistics_belt_counts_match {
    expression: index(${distribution_centers.logistics_belt}, 1) = "East Coast Atlantic Port"
      AND index(${distribution_centers.count}, 1) = 2
      AND index(${distribution_centers.logistics_belt}, 2) = "Midwest Heartland Freight Titan"
      AND index(${distribution_centers.count}, 2) = 2
      AND index(${distribution_centers.logistics_belt}, 3) = "Pacific West Coast Gateway"
      AND index(${distribution_centers.count}, 3) = 1
      AND index(${distribution_centers.logistics_belt}, 4) = "Southern Gulf & Sunbelt Hub"
      AND index(${distribution_centers.count}, 4) = 5 ;;
  }
}
