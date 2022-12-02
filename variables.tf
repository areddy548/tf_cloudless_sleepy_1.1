variable "vsphere_user" {

}
variable "vsphere_password" {

}
variable "vsphere_server" {

}
variable "vsphere_datacenter" {
}
variable "vsphere_datastore" {
  default = "datastore-114"
}
variable "vsphere_network" {
  default = "dvportgroup-102"
}
variable "vsphere_virtual_machine" {
  default = "raj-log"
}