locals {
  common_tags = {
    CreatedBy    = "${var.project_owner}"
    CreatedOn    = formatdate("DD-MM-YYYY", timeadd(timestamp(), "5h30m"))
    CreationMode = "IaC"
    Project      = "${var.project}"
  }
}