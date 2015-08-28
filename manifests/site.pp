# This works with Puppet version 3.8.2 and will install MongoDB version 2.6.11
# It uses mongodb module provided by puppetlabs: https://forge.puppetlabs.com/puppetlabs/mongodb
# It generates warnings:
#   Warning: Scope(Apt::Source[downloads-distro.mongodb.org]): $include_src is deprecated and will be removed in the next major release, please use $include => { 'src' => false } instead
#   Warning: Scope(Apt::Source[downloads-distro.mongodb.org]): $key_server is deprecated and will be removed in the next major release, please use $key => { 'server' => hkp://keyserver.ubuntu.com:80 } instead.
#   Warning: Scope(Apt::Key[Add key: 492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10 from Apt::Source downloads-distro.mongodb.org]): $key_server is deprecated and will be removed in the next major release. Please use $server instead.
node 'cubitus' {
  class { '::mongodb::globals':
    manage_package_repo => true,
    server_package_name => 'mongodb-org',
  }->
  class {'::mongodb::server':
    auth => false,
  }->
  # Create database 'testdb' with user 'user1' and password 'pass1. Test access:
  # > mongo --username user1 --password pass1 testdb
  # Hashed password is generated from command line. Ex for user 'user1' and password 'pass1'
  # > echo -n 'user1:mongo:pass1' | md5sum | awk '{print $1}'
  mongodb::db { 'testdb':
    user => 'user1',
    password_hash => 'a15fbfca5e3a758be80ceaf42458bcd8',
  }
}
