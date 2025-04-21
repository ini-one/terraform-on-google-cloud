# Resource Block: Create a Compute Engine instance
resource "google_compute_instance" "myapp1" {
  # Meta-Argument: count
  count = 2
  name         = "myapp1-vm-${count.index}"
  machine_type = var.machine_type
  zone         = "us-central1-a"
  #tags        = [tolist(google_compute_firewall.fw_ssh.target_tags)[0], tolist(google_compute_firewall.fw_http.target_tags)[0]]
  tags = ["ssh-tag","webserver-tag"]
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }
  # Install Webserver
  metadata_startup_script = file("${path.module}/app1-webserver-install.sh")
  #metadata_startup_script = file("./app1-webserver-install.sh")
  # metadata = {
  #   startup-script = <<-EOF
  #           #!/bin/bash
  #           set -x
  #           sudo apt-get update --fix-missing
  #           sudo apt install -y telnet
  #           sudo apt install -y nginx
  #           sudo systemctl enable nginx
  #           sudo chmod -R 755 /var/www/html
  #           sudo mkdir -p /var/www/html/app1
  #           HOSTNAME=$(hostname)
  #           sudo echo "<!DOCTYPE html> <html> <body style='background-color:rgb(250, 210, 210);'> <h1>Welcome to ini-one - WebVM App1 </h1> <p><strong>VM Hostname:</strong> $HOSTNAME</p> <p><strong>VM IP Address:</strong> $(hostname -I)</p> <p><strong>Application Version:</strong> V1</p> <p>Google Cloud Platform - Demos</p> </body></html>" | sudo tee /var/www/html/app1/index.html
  #           sudo echo "<!DOCTYPE html> <html> <body style='background-color:rgb(250, 210, 210);'> <h1>Welcome to ini-one - WebVM App1 </h1> <p><strong>VM Hostname:</strong> $HOSTNAME</p> <p><strong>VM IP Address:</strong> $(hostname -I)</p> <p><strong>Application Version:</strong> V1</p> <p>Google Cloud Platform - Demos</p> </body></html>" | sudo tee /var/www/html/index.html
  #       EOF
  # }
  network_interface {
    subnetwork = google_compute_subnetwork.mysubnet.id   
    access_config {
      # Include this section to give the VM an external IP address
    }
  }
}