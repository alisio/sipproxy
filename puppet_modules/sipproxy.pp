node default {
  include 'mysql::server'
  include 'opensips::proxy'
  include 'opensips_control_panel'
}
