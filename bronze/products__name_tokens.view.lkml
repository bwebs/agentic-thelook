view: products__name_tokens {
  label: "Product Title Words"

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${products.id} AS STRING), '_', CAST(${word_offset} AS STRING)) ;;
  }

  dimension: word_offset {
    label: "Title Word Offset"
    description: "Zero-based position of the word token within the trimmed product title (0 = first word in title)."
    synonyms: ["word offset", "word position in title", "title token position"]
    type: number
    sql: products__name_tokens_offset ;;
  }

  dimension: name_token {
    label: "Raw Title Word Token"
    description: "Case-preserved individual word token unnested from the space-delimited product title."
    synonyms: ["name token", "raw title word"]
    type: string
    sql: ${TABLE} ;;
  }

  dimension: token_length {
    label: "Title Word Character Length"
    description: "Number of characters in the unnested product title word token."
    synonyms: ["token length", "word character length"]
    type: number
    sql: LENGTH(${name_token}) ;;
  }

  dimension: product_title_buzzword {
    label: "Product Title Buzzword"
    description: "Lowercased descriptive keyword unnested from the product catalog title."
    synonyms: ["product title buzzword", "title buzzword", "catalog keyword"]
    type: string
    sql: LOWER(${name_token}) ;;
  }

  measure: count {
    label: "Title Word Occurrences"
    description: "Total count of unnested word tokens across product catalog titles."
    synonyms: ["title word occurrences", "buzzword occurrences"]
    type: count
  }

  measure: avg_word_position_in_title {
    label: "Average Word Position in Title"
    description: "Mean zero-based word position of the keyword within product catalog titles."
    synonyms: ["avg word position in title", "average word offset"]
    tags: ["non_additive"]
    type: average
    sql: ${word_offset} ;;
    value_format_name: decimal_2
  }
}
