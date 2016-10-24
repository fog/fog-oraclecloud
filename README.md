# Fog::OracleCloud

Module for the 'fog' gem to support the Oracle Cloud (IaaS and PaaS)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fog-oraclecloud'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fog-oraclecloud

## Usage

Before you can use fog-aws, you must require it in your application:

```ruby
require 'fog/oraclecloud'
```

Since it's a bad practice to have your credentials in source code, you should load them from default fog configuration file: ```~/.fog```. This file could look like this:

```
default:
  oracle_username: <USERNAME>
  oracle_password: <PASSWORD>
  oracle_domain: <IDENTITY DOMAIN>
  oracle_region: <emea or remove if using US data centre>
  oracle_compute_api: <COMPUTE API>
  oracle_storage_api: <STORAGE_API>
```

### Example: Java Cloud Service
Get all Java Instances
```ruby
instances = Fog::OracleCloud[:java].instances
```
Create a Java Instance
```ruby
instance = Fog::OracleCloud[:java].instances.create(
    :service_name => 'TestWLS',
    :description => 'A new weblogic instance',
    :dba_name => 'SYS',
    :dba_password => 'password',
    :db_service_name => 'TestDB',
    :admin_password => 'Welcome1$',
    :admin_username => 'weblogic',
    :shape => 'oc3',
    :version => '12.2.1',
    :ssh_key => 'ssh-rsa AAAAB3NzaC1yc2...',
)
```
Delete an instance
```ruby
instance = Fog::OracleCloud[:java].instances.get('TestWLS')
# Have to add the database details in so that the tables in the database can be removed
instance.dba_name = 'Admin'
instance.dba_password = 'password'
instance.destroy()
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fog/fog-oraclecloud.

