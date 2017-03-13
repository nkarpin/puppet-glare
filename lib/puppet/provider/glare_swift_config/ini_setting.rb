Puppet::Type.type(:glare_swift_config).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:openstack_config).provider(:ini_setting)
) do

  def self.file_path
    '/etc/glare/glare-swift.conf'
  end

end
