define postgresql::role (
  $attributes="LOGIN",
) {
  exec {"Create ${name}":
    command => "sudo -u postgres psql -tAc \"CREATE ROLE ${name} ${attributes}\"",
    unless => "sudo -u postgres psql -tAc \"SELECT 1 FROM pg_roles WHERE rolname='${name}'\" | grep -q 1"
  }
}