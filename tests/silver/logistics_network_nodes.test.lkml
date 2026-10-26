include: "../../silver/explores/logistics_network_nodes.explore.lkml"

test: logistics_network_nodes_warehouse_hubs_by_belt {
  explore_source: logistics_network_nodes {
    column: logistics_belt { field: logistics_network_nodes.logistics_belt }
    column: count { field: logistics_network_nodes.count }
    filters: [logistics_network_nodes.network_node_type: "Physical Warehouse Hub"]
    sorts: [logistics_network_nodes.logistics_belt: asc]
  }
  assert: warehouse_hub_belt_counts_match {
    expression: index(${logistics_network_nodes.logistics_belt}, 1) = "East Coast Atlantic Port"
      AND index(${logistics_network_nodes.count}, 1) = 2
      AND index(${logistics_network_nodes.logistics_belt}, 2) = "Midwest Heartland Freight Titan"
      AND index(${logistics_network_nodes.count}, 2) = 2
      AND index(${logistics_network_nodes.logistics_belt}, 3) = "Pacific West Coast Gateway"
      AND index(${logistics_network_nodes.count}, 3) = 1
      AND index(${logistics_network_nodes.logistics_belt}, 4) = "Southern Gulf & Sunbelt Hub"
      AND index(${logistics_network_nodes.count}, 4) = 5 ;;
  }
}
