node default {
  package { [ 'epel-release',
              'mlocate',
              'net-tools',
              'ngrep',
              'telnet']:
    ensure => installed,
  }
  -> class {'selinux':
    mode => 'disabled',
  }
  -> class { 'mysql::server':
    root_password => 'opensips',
  }
  -> class {'opensips_control_panel':}
  -> class {'opensips::proxy':
  }
}
