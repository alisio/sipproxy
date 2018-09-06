# == Class: sipproxy
#
# Full description of class sipproxy here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'sipproxy':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2018 Your name here, unless otherwise noted.
#
# pre requisitos: puppet module install mayflower-php --version 4.0.0-beta1

class control_panel (
  $db_server_ip = 'localhost',
  $db_server_port = 3306,
  $db_root_pw = 'opensips',
  $db_opensips_db = 'opensips',
  $db_opensips_pw = 'opensipsrw',
  $opensips_cp_packages = ['httpd',
                          'php',
                          'php-gd',
                          'php-mysql',
                          'php-xmlrpc',
                          'php-pear',
                          'php-pecl-apc',
                          'unzip',
                          'wget'],
  $proxy_transport = 'udp',
  $proxy_ip = $ipaddress,
  $opensips_cp_folder = '/var/www/html/opensips-cp',
  $opensips_cp_alias_folder = '/cp',
  ){
  package { $opensips_cp_packages:
    ensure => installed,
    notify => Exec['install pear packages'],
  }
  service { 'httpd':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    require => Package[$opensips_cp_packages],
  }
  exec { 'install pear packages':
    command => "pear install MDB2 MDB2#mysql log",
    path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    refreshonly => true,
  }
  file { '/etc/httpd/conf.d/opensips_cp.conf':
    ensure => file,
    content => template('opensips_cp/etc/httpd/conf.d/opensips_cp.conf.erb'),
    mode => '0644',
  }
  file_line { 'php_config':
    ensure            => present,
    path              => '/etc/php.ini',
    match             => '^ *short_open_tag *=.*',
    match_for_absence => true,
    line   => "short_open_tag = On",
    require => Package[$opensips_cp_packages],
    notify => Service['httpd'],
  }
  file { $opensips_cp_folder:
    ensure => directory,
    recurse => 'remote',
    source => "puppet:///modules/opensips_cp/$opensips_cp_folder",
    mode => '0644',
    owner => 'apache',
    group => 'apache'
  }
}
