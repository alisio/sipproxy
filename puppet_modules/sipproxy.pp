node default {
  class { 'mysql::server':
    root_password => 'opensips',
  }
  class {'opensips::proxy':
    opensips_script_mode => 'trunking',
  }

  include 'opensips_control_panel'
}
