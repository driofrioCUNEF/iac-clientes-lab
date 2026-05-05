resource "google_compute_instance" "frontend" {
  name         = "frontend"
  machine_type = "e2-micro"
  zone         = "${var.region}-a"

  tags = ["frontend"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y apache2
    systemctl start apache2
    echo '<html><body><h1>Server UP</h1><div id="data">El servidor está funcionando</div></body></html>' > /var/www/html/index.html
  EOT
}
