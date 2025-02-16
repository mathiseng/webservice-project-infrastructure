# Firewall rule to allow SSH access to instances in the network
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"] # Allows SSH access via port 22
  }

  source_ranges = ["0.0.0.0/0"] # Open to all IPs (should be restricted for security)
}
