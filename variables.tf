variable "environment" {
description = "Name of the environment"
default = "terraform"
}
variable "location" {
description = "Azure location to use"
default = "Australia East"
}
variable "reseau" {
description = "Azure network to use"
default = "net1"
}
variable "sreseau" {
description = "Azure subnet to use"
default = "subnet1"
}
variable "sreseaucidr" {
description = "azure subnet_cidr to use"
default = ["10.0.0.0/24"]
}
variable "versionnsg" {
description = "Name of the nsg"
default = "linux-vm-nsg"
}
