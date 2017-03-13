# == Class: glare::backend::vsphere
#
# Setup Glare to backend images into VMWare vCenter/ESXi
#
# === Parameters
#
# [*vcenter_insecure*]
#   (optional) If true, the ESX/vCenter server certificate is not verified.
#   If false, then the default CA truststore is used for verification.
#   This option is ignored if "vcenter_ca_file" is set.
#   Defaults to 'True'.
#
# [*vcenter_ca_file*]
#   (optional) The name of the CA bundle file which will be used in
#   verifying vCenter server certificate. If parameter is not set
#   then system truststore is used. If parameter is set,
#   vcenter_insecure value is ignored.
#   Defaults to $::os_service_default.
#
# [*vcenter_datastores*]
#   (Multi-valued) A list of datastores where the image
#   can be stored. This option may be specified multiple times
#   for specifying multiple datastores. The datastore name should
#   be specified after its datacenter path, seperated by ":".
#   An optional weight may be given after the datastore name,
#   seperated again by ":". Thus, the required format
#   becomes <datacenter_path>:<datastore_name>:<optional_weight>.
#   When adding an image, the datastore with highest weight will be selected,
#   unless there is not enough free space available in cases where the image
#   size is already known. If no weight is given, it is assumed to be
#   zero and the directory will be considered for selection last.
#   If multiple datastores have the same weight, then the one with the most
#   free space available is selected.
#   Defaults to $::os_service_default.
#
# [*vcenter_host*]
#   (required) vCenter/ESXi Server target system.
#   Should be a valid an IP address or a DNS name.
#
# [*vcenter_user*]
#   (required) Username for authenticating with vCenter/ESXi server.
#
# [*vcenter_password*]
#   (required) Password for authenticating with vCenter/ESXi server.
#
# [*vcenter_image_dir*]
#   (required) The name of the directory where the glare images will be stored
#   in the VMware datastore.
#
# [*vcenter_task_poll_interval*]
#   (optional) The interval used for polling remote tasks invoked on
#   vCenter/ESXi server.
#   Defaults to $::os_service_default.
#
# [*vcenter_api_retry_count*]
#   (optional) Number of times VMware ESX/VC server API must be retried upon
#   connection related issues.
#   Defaults to $::os_service_default.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false.
#
class glare::backend::vsphere(
  $vcenter_host,
  $vcenter_user,
  $vcenter_password,
  $vcenter_image_dir,
  $vcenter_datastores,
  $vcenter_ca_file            = $::os_service_default,
  $vcenter_insecure           = 'True',
  $vcenter_task_poll_interval = $::os_service_default,
  $vcenter_api_retry_count    = $::os_service_default,
  $multi_store                = false,
) {

  include ::glare::deps

  glare_config {
    'glare_store/vmware_insecure': value           => $vcenter_insecure;
    'glare_store/vmware_ca_file': value            => $vcenter_ca_file;
    'glare_store/vmware_server_host': value        => $vcenter_host;
    'glare_store/vmware_server_username': value    => $vcenter_user;
    'glare_store/vmware_server_password': value    => $vcenter_password;
    'glare_store/vmware_store_image_dir': value    => $vcenter_image_dir;
    'glare_store/vmware_task_poll_interval': value => $vcenter_task_poll_interval;
    'glare_store/vmware_api_retry_count': value    => $vcenter_api_retry_count;
    'glare_store/vmware_datastores': value         => $vcenter_datastores;
  }

  if !$multi_store {
    glare_config {  'glare_store/default_store': value => 'vsphere'; }
  }
}