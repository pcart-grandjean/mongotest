node 'cubitus' {
  class {'::mongodb::server':
    auth => true,
  }
  # Create database 'testdb' with user 'user1' and password 'pass1'
  # Hashed password is generated from command line. Ex for user 'user1' and password 'pass1'
  # > echo -n 'user1:mongo:pass1' | md5sum | awk '{print $1}'
  mongodb::db { 'testdb':
    user => 'user1',
    password_hash => 'a15fbfca5e3a758be80ceaf42458bcd8',
  }
}
