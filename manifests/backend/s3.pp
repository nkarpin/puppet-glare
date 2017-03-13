# == class: glare::backend::s3
#
# configures the storage backend for glare
# as a s3 instance
#
# === parameters:
#
#  [*access_key*]
#    (Required) The S3 query token access key.
#
#  [*secret_key*]
#    (Required) The S3 query token secret key.
#
#  [*host*]
#    (Required) The host where the S3 server is listening.
#
#  [*bucket*]
#    (Required) The S3 bucket to be used to store the Glance data.
#
#  [*bucket_url_format*]
#    (Optional) The S3 calling format used to determine the bucket. Either
#    'subdomain' or 'path' can be used.
#    Default: $::os_service_default.
#
#  [*create_bucket_on_put*]
#    (Optional) A boolean to determine if the S3 bucket should be created on
#    upload if it does not exist or if an error should be returned to the user.
#    Default: $::os_service_default.
#
#  [*large_object_size*]
#    (Optional) What size, in MB, should S3 start chunking image files and do a
#    multipart upload in S3.
#    Default: $::os_service_default.
#
#  [*large_object_chunk_size*]
#    (Optional) What multipart upload part size, in MB, should S3 use when
#    uploading parts. The size must be greater than or equal to 5M.
#    Default: $::os_service_default.
#
#  [*object_buffer_dir*]
#    (Optional) The local directory where uploads will be staged before they are
#    transferred into S3.
#    Default: $::os_service_default.
#
#  [*thread_pools*]
#    (Optional) The number of thread pools to perform a multipart upload in S3.
#    Default: $::os_service_default.
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
class glare::backend::s3(
  $access_key,
  $secret_key,
  $host,
  $bucket,
  $bucket_url_format        = $::os_service_default,
  $create_bucket_on_put     = $::os_service_default,
  $large_object_size        = $::os_service_default,
  $large_object_chunk_size  = $::os_service_default,
  $object_buffer_dir        = $::os_service_default,
  $thread_pools             = $::os_service_default,
  $multi_store              = false,
) {

  include ::glare::deps

  if !is_service_default($large_object_chunk_size){
    if !is_integer($large_object_chunk_size) or $large_object_chunk_size < 5 {
      fail('glare::backend::s3::large_object_chunk_size must be an integer >= 5')
    }
  }

  if !is_service_default($bucket_url_format){
    if !($bucket_url_format in ['subdomain', 'path']) {
      fail('glare::backend::s3::bucket_url_format must be either "subdomain" or "path"')
    }
  }

  glare_config {
    'glare_store/s3_store_access_key':              value => $access_key;
    'glare_store/s3_store_secret_key':              value => $secret_key;
    'glare_store/s3_store_host':                    value => $host;
    'glare_store/s3_store_bucket':                  value => $bucket;
    'glare_store/s3_store_bucket_url_format':       value => $bucket_url_format;
    'glare_store/s3_store_create_bucket_on_put':    value => $create_bucket_on_put;
    'glare_store/s3_store_large_object_size':       value => $large_object_size;
    'glare_store/s3_store_large_object_chunk_size': value => $large_object_chunk_size;
    'glare_store/s3_store_thread_pools':            value => $thread_pools;
    'glare_store/s3_store_object_buffer_dir':       value => $object_buffer_dir;
  }

  if !$multi_store {
    glare_config { 'glare_store/default_store': value => 's3'; }
  }

}