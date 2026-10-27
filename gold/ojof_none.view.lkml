view: ojof_none {
  derived_table: {
    sql: SELECT 0 AS pk FROM UNNEST(ARRAY<INT64>[]) AS pk ;;
  }

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: number
    sql: ${TABLE}.pk ;;
  }
}
