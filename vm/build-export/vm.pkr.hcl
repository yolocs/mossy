packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

source "googlecompute" "nginx" {
  project_id              = "gochen"
  source_image            = "ubuntu-2004-focal-v20241115"
  image_name              = "packer-nginx-{{timestamp}}"
  image_family            = "packer-nginx"
  image_storage_locations = ["us-central1"]
  image_labels = {
    "os" : "ubuntu"
    "application" : "nginx"
  }
  ssh_username       = "packer"
  instance_name      = "packer-nginx-image-build"
  zone               = "us-central1-a"
  use_iap            = true
  use_internal_ip    = true
  omit_external_ip   = true
  use_os_login       = true
  enable_secure_boot = true

  service_account_email = "packer@gochen.iam.gserviceaccount.com"

  tags = ["nginx", "packer"]
}

build {
  sources = [
    "source.googlecompute.nginx"
  ]

  provisioner "shell" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get upgrade -y",
      "sudo apt install -y nginx",
    ]
  }

  post-processor "googlecompute-export" {
    paths = [
      "gs://gochen-vms/packer-nginx/v0/packer-nginx-{{timestamp}}.tar.gz"
    ]
    keep_input_artifact = true
  }
}
