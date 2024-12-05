packer {
  required_plugins {
    googlecompute = {
      source  = "github.com/hashicorp/googlecompute"
      version = "~> 1"
    }
  }
}

variable "project_id" {
  type    = string
  default = env("PROJECT_ID")
}

variable "build_label" {
  type    = string
  default = env("BUILD_LABEL")
}

variable "builder_service_account" {
  type    = string
  default = env("BUILDER_SERVICE_ACCOUNT")
}

variable "cred_file" {
  type    = string
  default = env("CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE")
}

source "googlecompute" "nginx" {
  project_id              = var.project_id
  source_image            = "ubuntu-2004-focal-v20241115"
  image_name              = "mossy-nginx-${var.build_label}"
  image_family            = "mossy-nginx"
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

  service_account_email = var.builder_service_account
  credentials_file      = var.cred_file

  tags = ["nginx", "mossy"]
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

  # This processor is likely having a bug.
  # post-processor "googlecompute-export" {
  #   service_account_email = var.builder_service_account
  #   credentials_file      = var.cred_file

  #   paths = [
  #     "gs://gochen-vms/mossy-nginx-${var.build_label}.tar.gz"
  #   ]
  #   keep_input_artifact = true
  # }
}
