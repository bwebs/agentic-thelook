include: "../distribution_centers.view.lkml"
include: "../distribution_centers.refinement.lkml"

explore: distribution_centers_base {
  label: "Distribution Centers (Base)"
  view_name: distribution_centers
  hidden: yes
}
