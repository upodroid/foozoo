/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

module "gce-container" {
  source = "github.com/terraform-google-modules/terraform-google-container-vm"
  version = "1.0.0"

  container = {
    image = "${var.gcrimage}"

    volumeMounts = [
      {
        mountPath = "/cache"
        name      = "tempfs-0"
        readOnly  = "false"
      },
    ]
  }
  volumes = [
    {
      name = "tempfs-0"

      emptyDir = {
        medium = "Memory"
      }
    },
  ]

  restart_policy = "Always"
}

resource "google_compute_instance" "jen-dev" {
  name         = "${var.instancename}"
  machine_type = "g1-small"
  tags = ["public"]
  boot_disk {
    initialize_params {
      image = "${module.gce-container.source_image}"
    }
  }

  network_interface {
    subnetwork         = "main"
    access_config      = {}
  }

  metadata {
    "gce-container-declaration" = "${module.gce-container.metadata_value}"
  }

  labels {
    "container-vm" = "${module.gce-container.vm_container_label}"
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}