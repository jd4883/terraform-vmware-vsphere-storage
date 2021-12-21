module "datastore_tags" {
  for_each         = var.datastore_tags
  source           = "jd4883/vsphere-tags/vmware"
  name             = each.key
  description      = each.value
  associable_types = ["Datastore", "Datastore Cluster"]
}
