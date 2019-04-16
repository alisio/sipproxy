node default {
  package { [ 'epel-release',
              'net-tools',
              'ngrep',
              'telnet']:
    ensure => installed,
  }
  -> class { 'mysql::server':
    root_password => 'opensips',
  }
  -> class {'opensips_control_panel':}
  -> class {'opensips::proxy':
    opensips_script_mode => 'trunking',
  }
}
