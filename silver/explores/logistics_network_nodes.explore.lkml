include: "/bronze/users.view.lkml"
include: "/bronze/users.refinement.lkml"
include: "/silver/logistics_network_nodes.view.lkml"

explore: logistics_network_nodes {
  label: "Logistics Network Nodes"
  view_name: logistics_network_nodes
  hidden: no
  fields: [
    ALL_FIELDS*,
    -logistics_network_nodes.id,
    -logistics_network_nodes.mean_warehouse_latitude
  ]

  join: _sdt_users {
    from: users
    sql: ;;
    relationship: one_to_one
    fields: []
  }

  query: warehouse_and_metro_network_nodes {
    description: "Regional network map combining physical warehouse hubs and high-density US customer metro clusters (150+ shoppers) with rounded geographic coordinates."
    dimensions: [
      logistics_network_nodes.network_node_type,
      logistics_network_nodes.name,
      logistics_network_nodes.latitude,
      logistics_network_nodes.longitude
    ]
    sorts: [
      logistics_network_nodes.network_node_type: asc,
      logistics_network_nodes.name: asc
    ]
    limit: 25
  }
}
