include postgresql::params

class postgresql::slave (
  $package_name=$postgresql::params::package_name,
  $master_address,
  $postgres_version="9.1",
  $cluster_name="main",
  $replication_user="replicator",
  $replication_password="thepassword",
  $replication_port="5432"
) inherits postgresql::params {
  $lock_file = "/etc/postgresql/lock-new-setup.lock"
  package {
    $package_name:
    ensure => present;
  }
  ->
  exec {"Stop postgresql":
    command => "sudo service postgresql stop",
    creates => $lock_file;
  }
  ->
  exec {"Clean up old cluster directory":
    command => "rm -rf /var/lib/postgresql/${postgres_version}/${cluster_name}",
    creates => $lock_file;
  }
  ->
  file {"Create pgpass file":
    path => '/var/lib/postgresql/.pgpass',
    content => "${master_address}:*:*:${replication_user}:${replication_password}",
    owner => 'postgres',
    mode => '0600',
  }
  ->
  exec {"Starting base backup as replicator":
    command => "sudo -u postgres pg_basebackup -h ${master_address} -D /var/lib/postgresql/${postgres_version}/${cluster_name} -U ${replication_user} -v -P -w",
    creates => $lock_file;
  }
  ->
  file {"Recovery file":
    path => "/var/lib/postgresql/${postgres_version}/${cluster_name}/recovery.conf",
    content => "standby_mode = 'on'
primary_conninfo = 'host=${master_address} port=${replication_port} user=${replication_user} password=${replication_password} sslmode=prefer'
trigger_file = '/tmp/postgresql.trigger'",
  }
  ->
  pg_config{
    "wal_level":
    value => 'hot_standby';
    "max_wal_senders":
    value => 3;
    "checkpoint_segments":
    value => 8;
    "wal_keep_segments":
    value => 8;
    "hot_standby":
    value => 'on';
    "ssl":
    value => false;
  }
  ->
  exec {"Restart postgresql":
      command => "sudo service postgresql start",
      creates => $lock_file;
  }
  ->
  file {"Create lock-file":
      path => $lock_file,
      content => "If this file is removed, the cluster will be destroyed and recreated by puppet!"
  }
  ->
  service{"postgresql":
    ensure => running;
  }
}