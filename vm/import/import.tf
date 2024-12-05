provider "google" {}

resource "google_compute_image" "packer_nginx" {
  project           = "gochen"
  name              = "packer-nginx-imported"
  family            = "packer-nginx"
  storage_locations = ["us-central1"]
  raw_disk {
    source = "https://storage.googleapis.com/storage/v1/b/gochen-vms/o/packer-nginx/v0/packer-nginx-1732313160.tar.gz"
  }
}

output "packer_nginx_img_id" {
  value = google_compute_image.packer_nginx.id
}