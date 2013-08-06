Puppet::Type.type(:pg_config).provide(
    :ini_setting,
    # set ini_setting as the parent provider
    :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do
  # implement section as the first part of the namevar
  def section
    ''
  end
  def setting
    # implement setting as the second part of the namevar
    resource[:name]
  end
  def self.namevar(section_name, setting)
    "#{setting}"
  end
  # hard code the file path (this allows purging)
  def self.file_path
    '/etc/postgresql/9.1/main/postgresql.conf'
  end
end