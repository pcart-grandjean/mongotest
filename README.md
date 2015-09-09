# mongotest

## Environment setup

### Install Puppet 4.x (mongodb module will fail)

```
$ wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb --no-check-certificate
...
$ sudo dpkg -i puppetlabs-release-pc1-trusty.deb
...
$ sudo apt-get update
...
$ sudo apt-get upgrade puppet-agent
...
$ /opt/puppetlabs/bin/puppet --version
4.2.0
```

### Install Puppet 3.x (mongodb module will work)

```
$ wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb --no-check-certificate
...
$ sudo dpkg -i puppetlabs-release-pc1-trusty.deb
...
$ sudo apt-get update
...
$ sudo apt-get upgrade puppet
...
$ /usr/bin/puppet --version
3.8.2
```


## Scenario

```
$ sudo /opt/puppetlabs/bin/puppet apply --modulepath=forge manifests/site.pp
...
$ mongod -version
db version v2.4.9
Wed Jul 15 18:32:51.268 git version: nogitversion
$ mongo --username user1 --password pass1 testdb
MongoDB shell version: 2.4.9
connecting to: testdb
Wed Jul 15 18:31:30.068 Error: 18 { code: 18, ok: 0.0, errmsg: "auth fails" } at src/mongo/shell/db.js:228
exception: login failed
$ mongo --username user1 --password a15fbfca5e3a758be80ceaf42458bcd8 testdb
MongoDB shell version: 2.4.9
connecting to: testdb
>
...

```
