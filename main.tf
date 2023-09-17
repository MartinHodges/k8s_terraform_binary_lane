terraform {
required_version = ">= 1.5.5"
  required_providers {
    restapi = {
      source = "Mastercard/restapi"
    }
    ssh = {
      source = "loafoe/ssh"
      version = "2.6.0"
    }
  }
}

module "tf_vpc" {
  source = "./modules/vpc"
  vpc_name = "tf_vpc"
}

output "tf_vpc" {
  description = "tf_vpc"
  value = module.tf_vpc.vpc_desc
}

module "vpn" {
  source = "./modules/public_vps"
  vps_name = "vpn"
  vps_flavour = "std-1vcpu"
  vpc_id = module.tf_vpc.vpc_desc.id
}

output "vpn" {
  description = "vpn"
  value = module.vpn.v4_ips
}

module "k8s_master" {
  source = "./modules/public_vps"
  vps_name = "k8s-master"
  vps_flavour = "std-2vcpu"
  vpc_id = module.tf_vpc.vpc_desc.id
}

output "k8s_master" {
  description = "k8s_master"
  value = module.k8s_master.v4_ips
}

module "k8s_node_1" {
  source = "./modules/public_vps"
  vps_name = "k8s-node-1"
  vps_flavour = "std-1vcpu"
  vpc_id = module.tf_vpc.vpc_desc.id
}

output "k8s_node_1" {
  description = "k8s_node_1"
  value = module.k8s_node_1.v4_ips
}

module "k8s_node_2" {
  source = "./modules/public_vps"
  vps_name = "k8s-node-2"
  vps_flavour = "std-1vcpu"
  vpc_id = module.tf_vpc.vpc_desc.id
}

output "k8s_node_2" {
  description = "k8s_node_2"
  value = module.k8s_node_2.v4_ips
}

resource "local_file" "inventory" {
  filename = "../k8s_ansible/inventory"
  content = templatefile("ansible_inventory.tftpl", {
    master_ip = module.k8s_master.v4_ips.public
    node_ips = [
      module.k8s_node_1.v4_ips.public,
      module.k8s_node_2.v4_ips.public
    ],
    vpn_ip = module.vpn.v4_ips.public
  })
}
