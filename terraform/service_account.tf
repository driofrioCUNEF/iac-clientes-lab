resource "google_service_account" "github_actions" {
  account_id   = "github-deployer"
  display_name = "GitHub Actions Service Account"
}

resource "google_project_iam_member" "run_admin" {
  project = var.project_id
  role   = "roles/run.admin"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "iam_admin" {
  project = var.project_id
  role   = "roles/iam.securityAdmin"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "run_invoker" {
  project = var.project_id
  role   = "roles/run.invoker"
  member = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "artifact_registry_writer" {
  role   = "roles/artifactregistry.writer"
  member = "serviceAccount:${google_service_account.github_deployer.email}"
}

resource "google_service_account_key" "github_key" {
  service_account_id = google_service_account.github_actions.name
  keepers = {
    last_updated = timestamp()
  }
}
