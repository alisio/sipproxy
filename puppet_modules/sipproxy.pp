node default {
  include 'mysql::server'
  include 'opensips::proxy'
  include 'opensips-cp::control_panel'
}
