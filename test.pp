node default {
  package {
    ["avahi-daemon", "mdns-scan"]:
      ensure => present
  }
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
}

node master inherits default {
  include postgresql::master

  postgresql::hba{
    "slave-replication":
      type => 'host',
      database => 'replication',
      user => 'replicator',
      cidr_address => '172.16.244.161/32',
      method => 'md5'
  }

  Pg_config {
    require => Package['postgresql'],
#    notify => Service['postgresql'],
  }
}

node slave inherits default {
  Package['avahi-daemon'] -> Exec['Stop postgresql']
  Pg_config {
    require => Package['postgresql'],
#    notify => Service['postgresql'],
  }
  class {"postgresql::slave":
    master_address => 'master.local'
  }
}