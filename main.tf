// Define Terraform backend to persist the state
terraform {
  backend "gcs" {
    bucket      = "patrickhamann-terraform"
    credentials = ".google.json"
  }
}

// External and local Variable declarations
variable "FASTLY_API_TOKEN" {}

variable "GCP_PROJECT_ID" {}
variable "GCS_ACCESS_KEY" {}
variable "GCS_SECRET_KEY" {}

locals {
  region = "us-central-1"

  domains = {
    staging = "staging.patrickhamann.dev"
    prod    = "www.patrickhamann.dev"
  }

  domain = "${lookup(local.domains, terraform.workspace, "")}"
}

// Provider definitions
provider "google" {
  credentials = "${file(".google.json")}"
  project     = "${var.GCP_PROJECT_ID}"
  region      = "${local.region}"
}

provider "fastly" {
  api_key = "${var.FASTLY_API_TOKEN}"
}

// Website static files storage bucket
resource "google_storage_bucket" "website" {
  name     = "${local.domain}"
  location = "US"
}

resource "google_storage_bucket_object" "index" {
  name          = "index.html"
  source        = "index.html"
  bucket        = "${google_storage_bucket.website.name}"
  cache_control = "max-age=0, s-max-age=3600"
}

// Fastly service
resource "fastly_service_v1" "website" {
  // Set service name to the environment domain
  name = "${local.domain}"

  // Set domain to environment domain
  domain {
    name = "${local.domain}"
  }

  // Configure GCS backend
  backend {
    name                  = "gcs"
    address               = "storage.googleapis.com"
    ssl_cert_hostname     = "storage.googleapis.com"
    use_ssl               = true
    port                  = 443
    first_byte_timeout    = 2000
    max_conn              = 200
    between_bytes_timeout = 1000
  }

  vcl {
    name    = "main"
    content = "${data.template_file.main.rendered}"
    main    = true
  }

  // Enable GZip compression for static files
  gzip {
    name          = "gzip html, css and js"
    extensions    = ["css", "js"]
    content_types = ["text/html", "text/css", "application/javascript"]
  }

  // Ensure we can easily teardown the service
  // Note: unsafe for production services
  force_destroy = true
}

// Template the VCL file
data "template_file" "main" {
  template = "${file("main.vcl")}"

  vars = {
    DOMAIN         = "${local.domain}"
    GCS_ACCESS_KEY = "${var.GCS_ACCESS_KEY}"
    GCS_SECRET_KEY = "${var.GCS_SECRET_KEY}"
  }
}

// Output the domain
output "address" {
  value = "${local.domain}"
}
