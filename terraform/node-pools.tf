# Service account for Kubernetes nodes
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}
