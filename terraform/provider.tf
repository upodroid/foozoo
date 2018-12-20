provider "google" {
  credentials = "${file("./terraform.json")}"
  project     = "${var.project_id}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}

terraform {
  backend "gcs" {
    bucket  = "terraform-dummy"
    prefix  = "foozoo"
    credentials = "terraform.json"
  }
}