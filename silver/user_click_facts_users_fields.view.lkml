view: user_click_facts_users_fields {
  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${users.id} ;;
  }

  dimension: is_channel_attribution_mirage {
    label: "Channel Attribution Mirage Divergence"
    group_label: "Channel Attribution"
    description: "Clickstream Attribution Mirage Divergence flags customers whose original signup marketing channel disagrees with the session traffic channel of their latest browsing visit (users.traffic_source != last_touch_event_source). Marketing analytics teams use this reconciliation to quantify how often first-touch profile attribution diverges from last-touch session activity."
    synonyms: ["is channel attribution mirage", "clickstream attribution mirage divergence", "profile vs last touch mismatch"]
    type: yesno
    sql: ${users.traffic_source} != ${user_click_facts.last_touch_event_source} ;;
  }
}
