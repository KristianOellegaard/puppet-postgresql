Puppet::Type.newtype(:pg_config) do
  ensurable
  newparam(:name, :namevar => true) do
    desc 'Key of the settings to be defined.'
    # namevar should be of the form section/setting
    newvalues(/\S+/)
  end
  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |v|
      case v
        when TrueClass, FalseClass
          v.to_s.strip
        else
          "'" + v.to_s.strip + "'"
      end
    end
  end
end