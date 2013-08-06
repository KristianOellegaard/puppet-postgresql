include postgresql::params

class postgresql::master (
  $package_name=$postgresql::params::package_name,
  $service_name=$postgresql::params::service_name,
  $listen_addresses='*'
) inherits postgresql::params {
  package {
    $package_name:
      ensure => present;
  }

  service {
    $service_name:
      ensure => running;
  }

  pg_config{
    "wal_level":
      value => 'hot_standby';
    "max_wal_senders":
      value => 3;
    "checkpoint_segments":
      value => 8;
    "wal_keep_segments":
      value => 8;
    "listen_addresses":
      value => $listen_addresses;
  }

  postgresql::role {
    "replicator":
      attributes => "REPLICATION LOGIN ENCRYPTED PASSWORD 'thepassword'";
  }
}