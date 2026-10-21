include: "../../silver/explores/distribution_centers.explore.lkml"

test: distribution_centers_metrics_at_fixed_id {
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
