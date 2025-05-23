# Resource Block: Create a single Compute Engine instance
resource "google_compute_instance" "myapp1" {
  name         = "myiniapp1"
  machine_type = "e2-micro"
  zone         = "us-central1-a"
  #tags        = [tolist(google_compute_firewall.fw_ssh.target_tags)[0], tolist(google_compute_firewall.fw_http.target_tags)[0]]
  tags = ["ssh-tag","webserver-tag"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  # Install Webserver
  #metadata_startup_script = file("${path.module}/app1-webserver-install.sh")
  metadata_startup_script = file("./app1-webserver-install.sh")
  network_interface {
    subnetwork = google_compute_subnetwork.inisubnet.id 
    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}