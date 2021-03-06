# This initialy worked with Puppet version 3.8.2
# Then I moved on to puppet version 4.2.1
# It uses mongodb module provided by puppetlabs: https://forge.puppetlabs.com/puppetlabs/mongodb
# Tested with modules:
# $ puppet module --modulepath forge list
# ├── puppetlabs-apt (v2.1.0)
# ├── puppetlabs-mongodb (v0.11.0)
# └── puppetlabs-stdlib (v4.6.0)
# It generates warnings:
#   Warning: Scope(Apt::Source[downloads-distro.mongodb.org]): $include_src is deprecated and will be removed in the next major release, please use $include => { 'src' => false } instead
#   Warning: Scope(Apt::Source[downloads-distro.mongodb.org]): $key_server is deprecated and will be removed in the next major release, please use $key => { 'server' => hkp://keyserver.ubuntu.com:80 } instead.
#   Warning: Scope(Apt::Key[Add key: 492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10 from Apt::Source downloads-distro.mongodb.org]): $key_server is deprecated and will be removed in the next major release. Please use $server instead.
node 'cubitus' {
  # Disable Transparent Huge Pages as recommended by mongoDB 3.0
  # http://docs.mongodb.org/manual/tutorial/transparent-huge-pages/
  exec { 'disable_transparent_hugepage_enabled':
    command => '/bin/echo never > /sys/kernel/mm/transparent_hugepage/enabled',
    unless  => '/bin/grep -c \'\\[never\\]\' /sys/kernel/mm/transparent_hugepage/enabled 2>/dev/null',
  }
  exec { 'disable_transparent_hugepage_defrag':
    command => '/bin/echo never > /sys/kernel/mm/transparent_hugepage/defrag',
    unless  => '/bin/grep -c \'\\[never\\]\' /sys/kernel/mm/transparent_hugepage/defrag 2>/dev/null',
  }

  # Adding this package source will make the installation of mongodb-org to pull version 3.0
  apt::source { 'mongodb-org-3.0':
    location => 'http://repo.mongodb.org/apt/ubuntu',
    release => 'trusty/mongodb-org/3.0', 
    repos => 'multiverse',
    include => {
      'src' => false,
      'deb' => true,
    }
  }->
  class { '::mongodb::globals':
    manage_package_repo => true,
    server_package_name => 'mongodb-org', # This installs mongoDB 2.6.11 or 3.0.6 if package source above added
    # server_package_name => 'mongodb', # This installs mongoDB 2.4.9 and fails
  }->
  class {'::mongodb::server':
    auth => false,
  }
  # Get databases definitions from Hiera
  $mongodbs = hiera('mongodbs')
  $mongodbdef = {
    require => Class['::mongodb::server'],
  }
  create_resources(::mongodb::db, $mongodbs, $mongodbdef)

#  # Create database hash in Puppet file
#  $mongodbs = {
#    'testdb' => {
#      user => 'user1',
#      password_hash => 'a15fbfca5e3a758be80ceaf42458bcd8',
#    },
#    'toto' => {
#      user => 'toto',
#      password_hash => 'f8cd7cd28ef5ea2e189b0b8b8cadd27b',
#    },
#  }

# Display a variable to debug it
#  notify { 'mongodbs':
#    message => $mongodbs,
#  }

#  # Specify databases in puppet file
#  mongodb::db { 'testdb':
#    user => 'user1',
#    password_hash => 'a15fbfca5e3a758be80ceaf42458bcd8',
#    require => Class['::mongodb::server'],
#  }
}
