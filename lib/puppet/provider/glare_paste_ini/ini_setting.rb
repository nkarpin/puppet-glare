Puppet::Type.type(:glare_paste_ini).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/glare/glare-paste.ini'
  end

end
