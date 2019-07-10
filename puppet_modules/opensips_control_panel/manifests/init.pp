# Class: opensips_control_panel
# ===========================
#
# Full description of class opensips_control_panel here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'opensips_control_panel':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2018 Your name here, unless otherwise noted.
#
class opensips_control_panel (
    $db_server_ip = 'localhost',
    $db_server_port = 3306,
    $db_root_pw = 'opensips',
    $db_opensips_db = 'opensips',
    $db_opensips_user = 'opensips',
    $db_opensips_pw = 'opensipsrw',
    $opensips_cp_packages = ['httpd',
                            'php',
                            'php-mysql',
                            'php-gd',
                            'php-pear',
                            'php-pecl-apc',
                            'unzip',
                            'wget'],
    $proxy_transport = 'udp',
    $proxy_ip = $ipaddress,
    $opensips_cp_folder = '/var/www/html/opensips-cp',
    $opensips_cp_alias_folder = '/cp',
    $opensips_cp_versao = '8.2.4',
    ){
    realize Package['epel-release']
    -> package { $opensips_cp_packages:
      ensure => installed,
    }
    ~> service { 'httpd':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
      require    => Package[$opensips_cp_packages],
    }
    file { '/etc/httpd/conf.d/opensips_cp.conf':
      ensure  => file,
      content => template("${name}/etc/httpd/conf.d/opensips_cp.conf.erb"),
      mode    => '0644',
    }
    file { '/etc/cron.d/opensips_stats_cron':
      ensure => file,
      source => "puppet:///modules/${name}/etc/cron.d/opensips_stats_cron",
      mode   => '0644',
    }
    ~> service { 'crond':
      ensure     => running,
      enable     => true,
      hasrestart => true,
      hasstatus  => true,
    }
    file { $opensips_cp_folder:
      ensure  => directory,
      recurse => 'remote',
      source  => "puppet:///modules/${name}/${opensips_cp_folder}_${opensips_cp_versao}",
      mode    => '0644',
      owner   => 'apache',
      group   => 'apache'
    }
    file { '/root/ocp_sql_dump.sql':
      ensure => file,
      mode   => '0644',
      source => "puppet:///modules/${name}/ocp_sql_dump.sql",
    }
    -> mysql::db { $db_opensips_db:
      user           => $db_opensips_user,
      password       => $db_opensips_pw,
      host           => $db_server_ip,
      grant          => ['ALL'],
      sql            => '/root/ocp_sql_dump.sql',
      import_cat_cmd => 'cat',
      import_timeout => 900,
    }
  }
