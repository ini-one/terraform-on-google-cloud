provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_firewall" "allow_ssh_http" {
  name    = "allow-ssh-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_instance" "debian_vm" {
  name         = "debian12-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  tags = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    network = "default"
    access_config {} # Enables external IP
  }

  # Inject SSH key manually (disable OS Login)
  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }

  # Optionally, disable OS Login if needed
  metadata_startup_script = <<EOT
sudo usermod -aG sudo ${var.ssh_user}
EOT

  service_account {
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

resource "null_resource" "post_install" {
  depends_on = [google_compute_instance.debian_vm]

  connection {
    type        = "ssh"
    user        = var.ssh_user
    host        = google_compute_instance.debian_vm.network_interface[0].access_config[0].nat_ip
    private_key = file(var.private_key_path)
  }

  provisioner "file" {
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/setup.sh",
      "sudo /tmp/setup.sh"
    ]
  }
}
