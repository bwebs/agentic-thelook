include: "events.view.lkml"

view: events__uri_segments {
  label: "Event URI Segments"

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${events.id} AS STRING), '_', CAST(events__uri_segments_offset AS STRING)) ;;
  }

  dimension: url_directory_depth_level {
    label: "URL Directory Depth Level"
    description: "Zero-based directory depth offset (0 = first segment, 1 = second segment, 2 = third segment) of a slash-delimited URI path segment."
    synonyms: ["segment offset", "directory depth", "url depth level"]
    type: number
    sql: events__uri_segments_offset ;;
  }

  dimension: uri_segment {
    label: "URI Path Segment"
    description: "Individual slash-delimited path token extracted from the event URI."
    synonyms: ["url segment", "path segment", "directory segment"]
    type: string
    sql: ${TABLE} ;;
  }
}
