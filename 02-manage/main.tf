terraform {
  required_version = ">= 1.13.4"
  required_providers {
    neo4jaura = {
      source  = "neo4j-labs/neo4jaura"
      version = "1.1.1"
    }
  }
}

provider "neo4jaura" {
}

data "neo4jaura_projects" "this" {}

locals {
  demoProject = [
    for project in data.neo4jaura_projects.this.projects : project.id
    if project.name == "TerraformDemo"
  ].0
}

resource "neo4jaura_instance" "update_example" {
  name           = "nodes-demo-update-example"
  # name           = "nodes-demo-update_example-v2" # In-place update example
  cloud_provider = "gcp"
  region         = "europe-west2"
  # region         = "europe-west1" # Update initiating instance replace
  memory         = "1GB"
  storage        = "2GB"
  type           = "professional-db"
  project_id     = local.demoProject
}

// Snapshot example
# resource "neo4jaura_snapshot" "before_release" {
#   instance_id = neo4jaura_instance.staging.instance_id
# }
#
# output "snapshot_id" {
#   value = neo4jaura_snapshot.before_release.snapshot_id
# }

output "instance_id" {
  value = neo4jaura_instance.update_example.instance_id
}
