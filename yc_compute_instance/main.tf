locals{
  labels = merge(var.labels,{name="${var.env}_${var.instance_name}"})
}

data "yandex_compute_image" "ubuntu-20-04" {
  family = var.image_family
}

data "template_file" "cloud_init" {
  template = file("cloud-init.tmpl.yaml")
  vars     = {
    user    = var.user
    ssh_key = file(var.public_key_path)
  }
}
resource "yandex_compute_instance" "server" {
  count =instance_count
  name        = "${var.env}-${var.instance_name}-${count.index+1}"
  folder_id   = var.folder_id
  platform_id = lookup(var.instance_type,var.env)
  zone        = var.zone
  hostname= "${var.env}-${var.instance_name}-${count.index+1}"

  labels = local.labels

  resources {
    core_fraction = var.core_fraction
    cores         = var.cores
    memory        = var.memory

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-20-04.id
      type     = var.disk_type
      size     = var.disk_size
    }
  }
  network_interface {
    //subnet_id = yandex_vpc_subnet.default-ru-central1-b.id
    subnet_id = var.subnet_id
    nat       = var.nat
    //    nat_ip_address=yandex_vpc_address.openvpn_external_ip_address.external_ipv4_address.
    security_group_ids = [var.security_group_ids]
  }

  metadata = {
    user-data          = data.template_file.cloud_init.rendered
    serial-port-enable = 1
  }

  provisioner "remote-exec" {
    inline =var.instance_init_script
    connection {
      type  = "ssh"
      user  = var.user
      //      private_key = file(var.private_key_path)
      host  = self.network_interface[0].nat_ip_address
      agent = true
    }
  }

  timeouts {
    create = "10m"
  }
  lifecycle {
    create_before_destroy = true
    //    ignore_changes = [boot_disk[0].initialize_params[0].image_id]
  }
  allow_stopping_for_update = true
}

