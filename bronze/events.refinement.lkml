include: "events.view.lkml"

view: +events {
  dimension: session_id {
    tags: ["foreign_key"]
  }

  dimension: uri_segments {
    hidden: yes
    description: "Array of slash-delimited directory segments extracted from the trimmed event URI."
    sql: SPLIT(TRIM(${uri}, '/'), '/') ;;
  }

  dimension: url_path_depth {
    label: "URL Path Depth"
    description: "Number of slash-delimited directory segments in the event URI path."
    synonyms: ["path depth", "uri path depth"]
    type: number
    sql: ARRAY_LENGTH(${uri_segments}) ;;
  }

  dimension: uri_department {
    label: "URI Department"
    description: "Department slug extracted from deep department links (/department/<slug>) in the event URI."
    synonyms: ["url department", "department slug"]
    type: string
    sql: REGEXP_EXTRACT(${uri}, r'/department/([^/]+)') ;;
  }

  dimension: uri_category {
    label: "URI Category (Raw)"
    description: "Raw URL-encoded product category slug extracted from deep category links (/category/<slug>) in the event URI."
    synonyms: ["url category raw", "category slug"]
    type: string
    sql: REGEXP_EXTRACT(${uri}, r'/category/([^/]+)') ;;
  }

  dimension: decoded_url_category {
    label: "Decoded URL Category"
    description: "URL-decoded product category name extracted from deep category links (/category/<slug>, with %20 and + decoded to spaces)."
    synonyms: ["decoded uri category", "url category", "category page"]
    type: string
    sql: REGEXP_REPLACE(${uri_category}, r'%20|\+', ' ') ;;
  }

  dimension: uri_brand {
    label: "URI Brand"
    description: "Brand slug extracted from deep brand links (/brand/<slug>) in the event URI."
    synonyms: ["url brand", "brand slug"]
    type: string
    sql: REGEXP_EXTRACT(${uri}, r'/brand/([^/]+)') ;;
  }

  measure: count {
    label: "Total Click Events"
    description: "Total volume of website interactions and clickstream events."
  }

  measure: unique_chaotic_sessions {
    label: "Unique Browsing Sessions"
    description: "Number of unique browsing sessions generating storefront traffic."
    type: count_distinct
    sql: ${session_id} ;;
  }

  measure: distinct_clicking_humans {
    label: "Distinct Clicking Shoppers"
    description: "Number of distinct shoppers generating website interactions."
    type: count_distinct
    sql: ${user_id} ;;
  }

  measure: cart_events {
    label: "Cart Events"
    description: "Number of clickstream events where shoppers add items to their cart (event_type = 'cart')."
    synonyms: ["carts", "add to cart events"]
    type: count
    filters: [event_type: "cart"]
  }

  measure: purchase_events {
    label: "Purchase Events"
    description: "Number of completed checkout clickstream events (event_type = 'purchase')."
    synonyms: ["purchases", "completed checkouts"]
    type: count
    filters: [event_type: "purchase"]
  }

  measure: cancel_events {
    label: "Rage-Quit Cancel Events"
    description: "Number of clickstream events where shoppers explicitly cancel out of a browsing flow (event_type = 'cancel')."
    synonyms: ["rage quit cancel events", "cancels", "cancel events"]
    type: count
    filters: [event_type: "cancel"]
  }

  measure: carts_per_purchase_ratio {
    label: "Carts per Purchase Ratio"
    description: "Ratio of add-to-cart events relative to completed checkout purchase events (cart_events / purchase_events)."
    synonyms: ["carts per purchase", "cart to purchase ratio"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${cart_events} / NULLIF(${purchase_events}, 0) ;;
    value_format_name: decimal_3
  }

  measure: cancel_to_cart_ratio {
    label: "Rage-Quit Cart Abandonment Ratio"
    description: "Rage-Quit Cart Abandonment Ratio compares how often shoppers explicitly cancel out of a browsing flow relative to add-to-cart events (cancel_events / cart_events). User experience designers monitor this ratio to see whether checkout friction or unexpected shipping fees are driving shoppers away at the last second."
    synonyms: ["cancel to cart pct", "cancel to cart ratio", "rage-quit cart abandonment ratio"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${cancel_events} / NULLIF(${cart_events}, 0) ;;
    value_format_name: percent_2
  }

  measure: ie_events {
    label: "Internet Explorer Events"
    description: "Number of website clickstream events originating from legacy Internet Explorer browsers (browser = 'IE')."
    synonyms: ["ie dinosaur events", "ie events", "legacy ie events"]
    type: count
    filters: [browser: "IE"]
  }

  measure: ie_event_share {
    label: "Internet Explorer Traffic Share (Dinosaur Tax)"
    description: "Internet Explorer Dinosaur Tax tracks what share of website traffic still comes from legacy Internet Explorer browsers relative to all clickstream events (ie_events / count)."
    synonyms: ["internet explorer dinosaur tax", "ie dinosaur pct", "ie dinosaur share", "ie traffic share"]
    tags: ["non_additive"]
    type: number
    sql: 1.0 * ${ie_events} / NULLIF(${count}, 0) ;;
    value_format_name: percent_2
  }

  measure: _event_span_seconds {
    hidden: yes
    description: "Elapsed seconds between the earliest and latest clickstream event timestamps within the grouping (TIMESTAMP_DIFF(MAX(created_at), MIN(created_at), SECOND))."
    tags: ["non_additive"]
    type: number
    sql: TIMESTAMP_DIFF(MAX(${created_raw}), MIN(${created_raw}), SECOND) ;;
  }

  measure: max_sequence_number {
    label: "Max Sequence Number"
    description: "Maximum clickstream step sequence number reached across events in the grouping."
    synonyms: ["max event sequence", "max step sequence"]
    tags: ["non_additive"]
    type: max
    sql: ${sequence_number} ;;
  }

  measure: avg_url_path_depth {
    label: "Average URL Path Depth"
    description: "Clickstream Deep-Link Engagement depth benchmark: average number of slash-delimited directory segments across visited event URIs."
    synonyms: ["avg url path depth", "average path depth", "mean url depth"]
    tags: ["non_additive"]
    type: average
    sql: ${url_path_depth} ;;
    value_format_name: decimal_2
  }

  measure: department_url_events {
    label: "Department Deep-Link Events"
    description: "Clickstream Deep-Link Engagement count of events landing on a URI containing a /department/<slug> deep link."
    synonyms: ["has department in url", "department page events", "department link hits"]
    type: count
    filters: [uri_department: "-NULL"]
  }

  measure: category_url_events {
    label: "Category Deep-Link Events"
    description: "Clickstream Deep-Link Engagement count of events landing on a URI containing a /category/<slug> deep link."
    synonyms: ["has category in url", "category page events", "category link hits"]
    type: count
    filters: [uri_category: "-NULL"]
  }

  measure: brand_url_events {
    label: "Brand Deep-Link Events"
    description: "Clickstream Deep-Link Engagement count of events landing on a URI containing a /brand/<slug> deep link."
    synonyms: ["has brand in url", "brand page events", "brand link hits"]
    type: count
    filters: [uri_brand: "-NULL"]
  }

  measure: approx_unique_sessions {
    label: "Approximate Unique Sessions"
    description: "HyperLogLog approximate count of distinct browsing sessions (session_id) for high-volume clickstream URI segment analysis."
    synonyms: ["approx sessions", "approximate browsing sessions", "approx unique sessions"]
    tags: ["non_additive"]
    type: number
    sql: APPROX_COUNT_DISTINCT(${session_id}) ;;
    value_format_name: decimal_0
  }
}
