{
  "access_grants": {},
  "explores": {},
  "fields": {
    "agentic_thelook.user_warehouse_proximity_facts.email_handle": {
      "allowed_values": null,
      "field": "email_handle",
      "field_type": "dimension",
      "file": "user_warehouse_proximity_facts.view.lkml",
      "hidden": false,
      "line": 1,
      "model": "agentic_thelook",
      "pii": true,
      "required_access_grants": [],
      "view": "user_warehouse_proximity_facts"
    },
    "agentic_thelook.users.email_handle": {
      "allowed_values": null,
      "field": "email_handle",
      "field_type": "dimension",
      "file": "bronze/users.refinement.lkml",
      "hidden": false,
      "line": 312,
      "model": "agentic_thelook",
      "pii": true,
      "required_access_grants": [],
      "view": "users"
    }
  },
  "views": {}
}
