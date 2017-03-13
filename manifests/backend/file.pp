# === class: glare::backend::file
#
# used to configure file backends for glare
#
# === parameters:
#
#  [*filesystem_store_datadir*]
#    Location where dist images are stored when
#    default_store == file.
#    Optional. Default: /var/lib/glare/images/
#
# [*multi_store*]
#   (optional) Boolean describing if multiple backends will be configured
#   Defaults to false
#
class glare::backend::file(
  $filesystem_store_datadir = '/var/lib/glare/images/',
  $multi_store              = false,
) {

  include ::glare::deps

  glare_config {
    'glare_store/filesystem_store_datadir': value => $filesystem_store_datadir;
  }

  if !$multi_store {
    glare_config { 'glare_store/default_store': value => 'file'; }
  }
}
