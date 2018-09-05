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

class opensips(
  $DB_serverIP = 'localhost',
  $DB_serverPort = 3306,
  $DB_rootPW = 'opensips',
  $DB_opensipsDB = 'opensips',
  $DB_opensipsPW = 'opensipsrw',
  $opensips_packages = ['opensips',\
                        'opensips-db_mysql',\
                        'opensips-httpd',\
                        'opensips-json'
                        'opensips-pua',\
                        'opensips-pua_usrloc']
  ){
  package { 'epel-release':
    ensure => installed,
  }
  yumrepo { 'Opensips-2.3':
    baseurl => 'http://yum.opensips.org/2.3/releases/el/7/$basearch',
    descr => 'Opensips 2.3 repository for CentOS7',
    enabled => '1',
    gpgcheck => '0',
    require => Package['epel-release'],
  }
  package { ${opensips_packages}:
    ensure => installed,
    require => Yumrepo['Opensips-2.3'],
  }
}
