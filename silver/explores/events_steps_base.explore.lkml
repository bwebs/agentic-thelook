include: "/bronze/events.view.lkml"
include: "/bronze/events.refinement.lkml"
include: "/bronze/events__uri_segments.view.lkml"
include: "/bronze/explores/events_base.explore.lkml"
include: "/silver/event_step_triplets.view.lkml"

explore: events_steps_base {
  extends: [events_base]
  view_name: events
  hidden: yes

  join: event_step_triplets {
    view_label: "Events"
    type: left_outer
    relationship: one_to_one
    sql_on: ${events.id} = ${event_step_triplets.id} ;;
    fields: [
      id,
      prev_event_type,
      next_event_type,
      oscillation_triplet,
      is_pogo_stick_oscillation,
      pogo_stick_oscillations
    ]
  }
}
