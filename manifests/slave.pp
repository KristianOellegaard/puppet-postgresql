include postgresql::params

class postgresql::slave (
  $package_name=$postgresql::params::package_name,
  $master_address
) inherits postgresql::params {
  package {
    $package_name:
    ensure => present;
  }
  ->
  exec {"Stop postgresql":
    command => "sudo service postgresql stop",
  }
  ->
#  exec {"Kill remains":
#    command => 'ps aux | grep "/[v]ar/lib/postgresql/9.1/main" | awk "{ print $2 }" | xargs kill -9',
#    returns => [0,123] # 123 means it was killed already
#  }
#  ~>
  exec {"Clean up old cluster directory":
    command => 'rm -rf /var/lib/postgresql/9.1/main',
  }
  ->
  file {"Create pgpass file":
    path => '/var/lib/postgresql/.pgpass',
    content => "${master_address}:*:*:replicator:thepassword",
    owner => 'postgres',
    mode => '0600',
  }
  ->
  exec {"Starting base backup as replicator":
    command => "sudo -u postgres pg_basebackup -h ${master_address} -D /var/lib/postgresql/9.1/main -U replicator -v -P -w",
  }
  ->
  file {"Recovery file":
    path => '/etc/postgresql/9.1/main/recovery.conf',
    content => "standby_mode = 'on'
primary_conninfo = 'host=${master_address} port=5432 user=replicator password=thepassword sslmode=prefer'
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
  }
}