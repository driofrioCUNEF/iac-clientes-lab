resource "google_compute_firewall" "allow_http" {
  name    = "allow-http-web"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["frontend"]
  description   = "Permitir tráfico HTTP a la VM"
}


resource "google_compute_firewall" "allow_ssh_from_gcp" {
  name    = "allow-ssh-from-gcp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"] # Rango oficial de IAP y Cloud Shell
  target_tags   = ["frontend"]
  description   = "Permitir SSH solo desde infraestructura de GCP como Cloud Shell e IAP"
}
