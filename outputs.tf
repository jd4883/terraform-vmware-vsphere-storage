output "content_libraries" {
  value = merge(
    {
      (vsphere_content_library.misc.name)    = vsphere_content_library.misc.id
      (vsphere_content_library.haproxy.name) = vsphere_content_library.haproxy.id
      (vsphere_content_library.tanzu.name)   = vsphere_content_library.tanzu.id
      (vsphere_content_library.vcf.name)     = vsphere_content_library.vcf.id
    }
  )
}

output "ds_cluster" { value = { for i in vsphere_datastore_cluster.datastore_cluster : i.name => i.id } }
output "ds" { value = { for i in vsphere_vmfs_datastore.ds : i.name => [i.id, i.tags] } }
