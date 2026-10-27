include: "/silver/explores/users.explore.lkml"
include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"
include: "/gold/channel_conversion_efficiency_dims.view.lkml"

explore: users_channel_conversion_efficiency {
  extends: [users]
  label: "Users (Annual Channel Signup-to-Purchase Efficiency)"
  view_name: users
  hidden: no
  tags: ["gold"]

  sql_always_where:
    {% if channel_events._in_query %}
      (
        ${users.id} IS NOT NULL
        AND {% condition channel_conversion_efficiency_dims.cohort_date_filter %} ${users.created_raw} {% endcondition %}
      )
      OR (
        ${channel_events.id} IS NOT NULL
        AND {% condition channel_conversion_efficiency_dims.cohort_date_filter %} ${channel_events.created_raw} {% endcondition %}
      )
    {% else %}
      {% condition channel_conversion_efficiency_dims.cohort_date_filter %} ${users.created_raw} {% endcondition %}
    {% endif %} ;;

  always_filter: {
    filters: [channel_conversion_efficiency_dims.cohort_date_filter: "2020/01/01 to 2027/01/01"]
  }

  join: channel_events {
    from: events
    view_label: "Channel Clickstream Events"
    type: full_outer
    relationship: many_to_many
    sql_on: FALSE ;;
  }

  join: channel_conversion_efficiency_dims {
    view_label: "Shared Year & Channel"
    relationship: one_to_one
    sql: ;;
  }

  query: annual_channel_signups_vs_purchases {
    description: "Annual comparison of new customer signups, clickstream purchase events, and purchases-to-signups ratio across marketing channels."
    dimensions: [
      channel_conversion_efficiency_dims.calendar_year,
      channel_conversion_efficiency_dims.channel
    ]
    measures: [
      users.count,
      channel_events.purchase_events,
      channel_conversion_efficiency_dims.purchases_to_signups_ratio
    ]
    filters: [
      channel_conversion_efficiency_dims.cohort_date_filter: "2020/01/01 to 2027/01/01",
      channel_conversion_efficiency_dims.calendar_year: "NOT NULL"
    ]
    sorts: [
      channel_conversion_efficiency_dims.calendar_year: desc,
      channel_events.purchase_events: desc
    ]
    limit: 25
  }
}
