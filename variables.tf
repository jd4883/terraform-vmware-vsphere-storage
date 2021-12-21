variable "datacenter_id" { type = string }
variable "datastore_tags" { type = map(string) }
variable "domain" { type = string }
variable "ds_clusters" {}
variable "hosts" {}
variable "preferred_datastore" { type = string }
variable "vmfs_datastores" {}
