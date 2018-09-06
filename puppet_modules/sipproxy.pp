node default {
  class { 'mysql::server':
    root_password => 'opensips',
  }
  include 'opensips::proxy'
  include 'opensips_control_panel'
}
