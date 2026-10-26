include: "/silver/explores/users.explore.lkml"
include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"
include: "/gold/state_channel_traffic_dims.view.lkml"

explore: users_state_channel_traffic {
  extends: [users]
  label: "Users (State & Channel Traffic Balance)"
  view_name: users
  hidden: no
  tags: ["gold"]

  join: state_events {
    from: events
    view_label: "State Clickstream Events"
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  join: state_channel_traffic_dims {
    view_label: "Shared State & Channel"
    relationship: one_to_one
    sql: ;;
  }

  query: top_state_channel_traffic_balance {
    description: "Top 20 state and marketing channel combinations ranked by clickstream event volume alongside US registered users and State-Channel Registration-to-Click Balance Regime."
    dimensions: [
      state_channel_traffic_dims.us_state,
      state_channel_traffic_dims.channel
    ]
    measures: [
      state_channel_traffic_dims.state_channel_balance_regime,
      users.us_registered_users,
      state_events.count
    ]
    filters: [state_channel_traffic_dims.us_state: "-NULL"]
    sorts: [state_events.count: desc]
    limit: 20
  }
}
