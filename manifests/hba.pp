define postgresql::hba (
  $type='host',
  $database='all',
  $user='all',
  $cidr_address='0.0.0.0',
  $method='password',
  $option=''
){
  file_line { "pg_hba_${name}":
    path => '/etc/postgresql/9.1/main/pg_hba.conf',
    line => "${type}    ${database}         ${user}         ${cidr_address}          ${method}        ${option}",
    require => Package['postgresql'],
    notify => Service['postgresql']
  }
}