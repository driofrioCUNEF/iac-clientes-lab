resource "google_artifact_registry_repository" "gcr_compat" {
  location      = var.region
  repository_id = "gcr-compat"
  format        = "DOCKER"
  description   = "Repositorio Docker compatible con gcr.io para clientes-api"

  docker_config {
    immutable_tags = false
  }
}

resource "google_cloud_run_service" "java_api" {
  name     = "clientes-api"
  location = var.region
  project  = var.project_id

  depends_on = [google_artifact_registry_repository.gcr_compat]
  
  template {
    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector"        = google_vpc_access_connector.vpc_connector.id
        "run.googleapis.com/vpc-access-egress"           = "all-traffic"
        "autoscaling.knative.dev/maxScale"               = "2"
      }
    }

    spec {
      containers {
        image = "gcr.io/cloudrun/hello"

        env {
          name  = "DB_HOST"
          value = google_sql_database_instance.default.connection_name
        }

        env {
          name  = "DB_USER"
          value = var.db_user
        }

        env {
          name  = "DB_PASSWORD"
          value = var.db_password
        }

        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}
