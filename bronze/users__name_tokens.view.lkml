view: users__name_tokens {
  label: "User Name Tokens"

  dimension: pk {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(CAST(${users.id} AS STRING), '_', CAST(${token_offset} AS STRING)) ;;
  }

  dimension: token_offset {
    label: "Name Token Offset"
    description: "Zero-based position of the name token within [first_name, last_name] (0 = given first name, 1 = family surname)."
    synonyms: ["token offset", "name array position"]
    type: number
    sql: users__name_tokens_offset ;;
  }

  dimension: name_slot {
    label: "Unnested Name Slot"
    description: "Identifies whether an unnested customer name token is the 'Given First-Name Token' (offset 0) or 'Family Surname Token' (offset 1)."
    synonyms: ["unnested name slot", "name token slot", "first vs surname token"]
    case: {
      when: {
        sql: ${token_offset} = 0 ;;
        label: "Given First-Name Token"
      }
      else: "Family Surname Token"
    }
  }

  dimension: name_token {
    label: "Name Token"
    description: "Individual given-name or surname token unnested from [first_name, last_name]."
    synonyms: ["unnested name", "name word"]
    type: string
    sql: ${TABLE} ;;
  }

  dimension: starting_letter {
    label: "Starting Initial"
    description: "Uppercase first character of the unnested given-name or surname token."
    synonyms: ["starting letter", "name token initial"]
    type: string
    sql: SUBSTR(UPPER(${name_token}), 1, 1) ;;
  }

  measure: count {
    label: "Name Token Occurrences"
    description: "Total count of unnested given-name and surname tokens across shoppers."
    synonyms: ["token occurrences", "name token count"]
    type: count
  }
}
