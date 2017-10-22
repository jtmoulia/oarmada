# Set the variable value in *.tfvars file
# or using -var="do_token=..." CLI option
variable "do_token" {}
variable "shed_do_region" {
  default = "sfo2"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

# Create the SSH key
resource "digitalocean_ssh_key" "oarmada_key" {
  name       = "oarmada key"
  public_key = "${file("/home/jtmoulia/.ssh/id_rsa.pub")}"
}

resource "digitalocean_tag" "shed" {
  name = "shed"
}

resource "digitalocean_volume" "shed-1-volume" {
  region      = "${var.shed_do_region}"
  name        = "shed-1-volume"
  size        = 20
  description = "block volume for shed-1"
}

resource "digitalocean_droplet" "shed-1-droplet" {
  image      = "ubuntu-16-04-x64"
  name       = "shed-1"
  region     = "${var.shed_do_region}"
  size       = "512mb"
  ssh_keys   = ["${digitalocean_ssh_key.oarmada_key.id}"]
  tags       = ["${digitalocean_tag.shed.id}"]
  volume_ids = ["${digitalocean_volume.shed-1-volume.id}"]
}

output "shed-1-ip" {
  value = "${digitalocean_droplet.shed-1-droplet.ipv4_address}"
}
