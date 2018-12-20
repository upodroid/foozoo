provider "google" {
  credentials = "${file("./terraform.json")}"
  project     = "${var.project_id}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}

terraform {
  backend "gcs" {
    bucket  = "upo-scripts"
    prefix  = "terraform/foozoo"
    credentials = "terraform.json"
  }
}