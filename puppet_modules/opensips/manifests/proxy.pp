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

class opensips::proxy(
  $db_mode='no',
  $db_server_ip = 'localhost',
  $db_server_port = 3306,
  $db_root_pw = 'opensips',
  $db_opensips_db = 'opensips',
  $db_opensips_pw = 'opensipsrw',
  $opensips_packages = ['opensips',
                        'opensips-db_mysql',
                        'opensips-httpd',
                        'opensips-json',
                        'opensips-pua',
                        'opensips-pua_usrloc'],
  $opensips_cfg = '/etc/opensips/opensips.cfg',
  $opensips_ctlrc = '/etc/opensips/opensipsctlrc',
  $opensips_yum_repo_baseurl = 'http://yum.opensips.org/2.3/releases/el/7/$basearch',
  $proxy_transport = 'udp',
  $proxy_ip = $ipaddress,
  $proxy_port = 5060,
  $proxy_eth_interface = 'eth0',
  ){
  package { 'epel-release':
    ensure => installed,
  }
  yumrepo { 'opensips':
    baseurl => $opensips_yum_repo_baseurl,
    descr => 'Opensips repository',
    enabled => '1',
    gpgcheck => '0',
    require => Package['epel-release'],
  }
  package { $opensips_packages:
    ensure => installed,
    require => Yumrepo['opensips'],
  }
  file { $opensips_cfg:
    ensure => file,
    mode => '0644',
    source => "puppet:///modules/opensips/$opensips_cfg",
    require => Package[$opensips_packages],
  }
  file_line { 'listen_interface_port':
    ensure            => present,
    path              => $opensips_cfg,
    match             => '^listen=.*',
    match_for_absence => true,
    line   => "listen=$proxy_transport:$proxy_ip:$proxy_port",
    require => File[$opensips_cfg],
  }
  service { 'opensips':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
    require => File_line['listen_interface_port'],
  }
  if $db_mode == 'yes' {
    #TODO  do db stuff here
    notify{'db message':
      message => 'Do database stuff here'
    }
  }
}
