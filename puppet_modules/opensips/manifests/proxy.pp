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
  $db_mode='db', # db or nodb
  $db_server_ip = 'localhost',
  $db_server_port = 3306,
  $db_root_pw = 'opensips',
  $db_opensips_db = 'opensips',
  $db_opensips_user = 'opensips',
  $db_opensips_pw = 'opensipsrw',
  $opensips_packages = ['opensips',
                        'opensips-db_mysql',
                        'opensips-httpd',
                        'opensips-json',
                        'opensips-pua',
                        'opensips-pua_usrloc',
                        'sngrep'],
  $opensips_cfg = '/etc/opensips/opensips.cfg',
  $opensips_ctlrc = '/etc/opensips/opensipsctlrc',
  $opensips_script_mode = 'default', # default, trunking, residential
  $opensips_yum_repo_baseurl = 'http://yum.opensips.org/2.4/releases/el/7/$basearch',
  $proxy_transport = 'udp',
  #$proxy_ip = $ipaddress,
  $proxy_port = 5060,
  $proxy_eth_interface = $interfaces,
  ){
  yumrepo { 'opensips':
    baseurl => $opensips_yum_repo_baseurl,
    descr => 'Opensips repository',
    enabled => '1',
    gpgcheck => '0',
    # require => Package['epel-release'],
  }
  -> yumrepo { 'irontec':
    baseurl => 'http://packages.irontec.com/centos/$releasever/$basearch/',
    descr => 'irontec repository',
    enabled => '1',
    gpgcheck => '0',
    # require => Package['epel-release'],
  }
  -> package { $opensips_packages:
    ensure => installed,
    require => Yumrepo['opensips'],
  }
  file { $opensips_cfg:
    ensure => file,
    mode => '0644',
    content => template("opensips/etc/opensips/opensips-${db_mode}-${opensips_script_mode}.cfg.erb"),
    require => Package[$opensips_packages],
    notify => Service['opensips']
  }
  file { '/etc/opensips/opensipsctlrc':
    ensure => file,
    mode => '0644',
    content => template("opensips/etc/opensips/opensipsctlrc-${db_mode}.erb"),
    require => Package[$opensips_packages],
    notify => Service['opensips']
  }
  if $db_mode == 'db' {

    exec { 'adicionar dominio':
      command => "opensipsctl domain add $proxy_ip",
      unless  =>  "opensipsctl domain show | egrep $proxy_ip",
      path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
      require => Service['opensips'],
    }
  }
  service { 'opensips':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus  => true,
  }
}
