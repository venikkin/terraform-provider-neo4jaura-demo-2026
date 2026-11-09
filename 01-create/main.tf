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

resource "neo4jaura_instance" "create_example" {
  name           = "nodes-demo-create-example"
  cloud_provider = "gcp"
  region         = "europe-west2"
  memory         = "1GB"
  storage        = "2GB"
  type           = "professional-db"
  project_id     = local.demoProject
}

output "instance_id" {
  value = neo4jaura_instance.create_example.instance_id
}

output "connection_url" {
  value = neo4jaura_instance.create_example.connection_url
}

output "password" {
  value     = neo4jaura_instance.create_example.password
  sensitive = true
}
