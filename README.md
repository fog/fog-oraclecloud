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

## Supported Services
The following services are supported:
* Java Cloud Service
  * create_instance
  * delete_instance
  * get_instance
  * get_server
  * list_instances
  * list_servers
* SOA Cloud Service
  * create_instance
  * delete_instance
  * get_instance
  * list_instances
* Database Cloud Service
  * backup_instance
  * create_instance
  * create_snapshot
  * delete_instance
  * delete_snapshot
  * get_instance
  * get_snapshot
  * list_backups
  * list_instances
  * list_patches
  * list_recoveries
  * list_servers
  * list_snapshots
  * recover_instance
  * scale_instance
* Compute Cloud Servcice
  * create_image
  * create_image_list
  * create_instance
  * create_orchestration
  * create_security_application
  * create_security_rule
  * create_ssh_key
  * create_volume
  * delete_image_list
  * delete_instance
  * delete_orchestration
  * delete_security_application
  * delete_ssh_key
  * get_image
  * get_image_list
  * get_instance
  * get_orchestration
  * get_security_application
  * get_security_rule
  * get_ssh_key
  * list_image_lists
  * list_images
  * list_instances
  * list_orchestrations
  * list_security_applications
  * list_security_lists
  * list_security_rules
  * list_ssh_keys
  * list_volumes
  * start_orchestration
  * stop_orchestration
  * update_image
  * update_image_list
  * update_orchestration
  * update_ssh_key
* Storage Cloud Service
  * create_container
  * delete_container
  * get_container
  * list_containers
  
These basically align with the REST API documentation on docs.oracle.com. Check there for particulars around parameters, types etc. 

**Note**: The APIs above are slightly modified from the Oracle cloud to provide consistency across requests. Keep in mind the following:
* All parameters are given in lower camel case (ie: service_name, not ServiceName)
* For IaaS services you don't need to provide the fully qualified names (ie: Compute/<identity_domain>/<name>). The system will prepend the configured user when necessary
* The Java and Database configuration has all the parameters as top level attributes (ie: don't configure parameters/content_port, use content_port)
* Smart defaults are included where possible. Check the code to see.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fog/fog-oraclecloud.

