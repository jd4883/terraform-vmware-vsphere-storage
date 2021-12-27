resource "vsphere_vmfs_datastore" "ds" {
  for_each             = var.vmfs_datastores
  name                 = each.key
  datastore_cluster_id = vsphere_datastore_cluster.datastore_cluster[each.value.cluster].id
  host_system_id       = var.hosts[each.value.hostname].id
  tags                 = sort([for k, v in module.datastore_tags : v.tag.id if contains(each.value.tags, k)])
  disks                = each.value.disks
  lifecycle {
    ignore_changes = [
      datastore_cluster_id,
      disks,
    ] # ensures a custom datastore cluster move is honored
  }
}

resource "vsphere_datastore_cluster" "datastore_cluster" {
  for_each                       = var.ds_clusters
  name                           = each.key
  datacenter_id                  = var.datacenter_id
  sdrs_automation_level          = lookup(each.value, "sdrs_automation_level", "manual")
  sdrs_default_intra_vm_affinity = tobool(lookup(each.value, "sdrs_default_intra_vm_affinity", false))
  sdrs_enabled                   = tobool(lookup(each.value, "sdrs_enabled", true))
}

resource "vsphere_content_library" "misc" {
  name = "Misc ISO's and OVA/OVF"
  storage_backing = [
    vsphere_vmfs_datastore.ds[var.preferred_datastore].id,
  ]
  description = "Misc ISO's and OVA/OVF"
  lifecycle { ignore_changes = [description] }
}

resource "vsphere_content_library" "haproxy" {
  name = "HAProxy"
  storage_backing = [vsphere_vmfs_datastore.ds[var.preferred_datastore].id]
  description = "HAProxy x86 Tanzu VM"
  lifecycle { ignore_changes = [description] }
}

resource "vsphere_content_library" "k8s_content" {
  name = "Tanzu K8s Content"
  storage_backing = [vsphere_vmfs_datastore.ds[var.preferred_datastore].id]
  description = "Tanzu K8s Content"
  lifecycle { ignore_changes = [description] }
}

#resource "vsphere_content_library_item" "haproxy" {
#  name        = "HAProxy v0.2.0"
#  description = "HAProxy v0.2.0"
#  library_id  = vsphere_content_library.haproxy.id
#  file_url    = "https://cdn.haproxy.com/download/haproxy/vsphere/ova/haproxy-v0.2.0.ova"
#}


resource "vsphere_content_library" "tanzu" {
  name = "Tanzu K8s Image"
  storage_backing = [vsphere_vmfs_datastore.ds[var.preferred_datastore].id]
  description = "Tanzu K8s Image"
  subscription {
    subscription_url = "https://wp-content.vmware.com/v2/latest/lib.json"
    automatic_sync   = true
    on_demand        = false
  }
  lifecycle { ignore_changes = [description] }
}

resource "vsphere_content_library" "vcf" {
  name = "VMWare Cloud Foundation"
  storage_backing = [vsphere_vmfs_datastore.ds[var.preferred_datastore].id]
  description = "VMWare Cloud Foundation"
  lifecycle { ignore_changes = [description] }
}
