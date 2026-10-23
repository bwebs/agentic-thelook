connection: "default_bigquery_connection"

include: "/bronze/**/*.view.lkml"
include: "/bronze/**/*.refinement.lkml"
include: "/bronze/explores/**/*.explore.lkml"
include: "/tests/**/*.test.lkml"
