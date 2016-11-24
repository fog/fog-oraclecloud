require 'pp'

Shindo.tests('Fog::Java[oraclecloud] | java requests', 'java') do

	tests("#java-create", "create") do
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
			:ssh_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlinstanceUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ==',
		)
		test "can create a java instance" do
			instance.is_a? Fog::OracleCloud::Java::Instance
		end	

		test "is being built" do
			!instance.ready?
		end
		instance.wait_for { ready? }

		test "is built" do
			instance.ready?
		end
	end
=begin
	tests('#java-read') do
		instances = Fog::OracleCloud[:java].instances
		test "returns an Array" do
			instances.is_a? Array
		end
	
		test "should return records" do
			instances.size >= 1
		end

		test "should return a valid name" do
			instances.first.service_name.is_a? String
		end

		instance = Fog::OracleCloud[:java].instances.get(instances.first.service_name)
		test "should return an instance" do
			instance.service_name.is_a? String
		end

		servers = instance.servers
		test "should have compute nodes" do
			servers.is_a? Array
			servers.size >= 1
			servers.first.status.is_a? String
		end
	end

	tests('test jcs scaling ') do
	  scale_out_server_name = 'TestWLS_server_1'
    test_service_name = 'TestWLS'
 
		test "scale out a cluster" do
		  instance = Fog::OracleCloud[:java].instances.get(test_service_name)
			instance.scale_out_a_cluster('testcluster',false)
			Fog::OracleCloud[:java].instances.get(test_service_name).wait_for(1800) { ready? }
			Fog::OracleCloud[:java].instances.get(test_service_name).ready?			
		end

    test('get server') do
      instance = Fog::OracleCloud[:java].instances.get(test_service_name)
      instance.ready? 
      server = instance.servers.get(test_service_name,scale_out_server_name)
      server.ready?   
    end
    
  	test "scale a node" do
  	  instance = Fog::OracleCloud[:java].instances.get(test_service_name)
  		instance.ready? 
  		server = instance.servers.get(test_service_name,scale_out_server_name)
  		server.scale('oc4')
  		Fog::OracleCloud[:java].instances.get(test_service_name).wait_for(1800) { ready? }
  		server = instance.servers.get(test_service_name,scale_out_server_name)
  		server.ready?
  		server.shape == 'oc4'
  	end
  
  	test "scale in a cluster" do
  	  instance = Fog::OracleCloud[:java].instances.get(test_service_name)
  		instance.ready? 
  		instance.servers.get(test_service_name,scale_out_server_name).scale_in_a_cluster
  		Fog::OracleCloud[:java].instances.get(test_service_name).wait_for(1800) { ready? }
  		Fog::OracleCloud[:java].instances.get(test_service_name).ready?
  	end
  
  end
=end

	tests('test jcs backup and restoration') do	 
    test_service_name = 'TestWLS'    
    #test_service_name = 'dengJCS'    
 
    instance = Fog::OracleCloud[:java].instances.get(test_service_name)
    if !instance.ready? 
      puts 'wait for ready....'
      Fog::OracleCloud[:java].instances.get(test_service_name).wait_for(1800) { ready? }
    end
    
    # Create a backup   
    response = instance.backup()
    test "should start backup" do
      response.body['operationName'].eql?('start-backup')
    end
    Fog::OracleCloud[:java].instances.get(test_service_name).wait_for(1800) { ready? }
    Fog::OracleCloud[:java].instances.get(test_service_name).ready?
   
    backups = instance.backups  
    test "returns an Array" do    
      backups.is_a? Array
	  end  
    test "should return records" do
      backups.size >= 1
    end   
    
	  backup = backups.get(test_service_name,backups.first.backup_id)
	  test "should return a backup" do
      backup.status.is_a? String
    end    

    # Create a restoration
    test_backup_id = backups.first.backup_id
    response = instance.restoration(test_backup_id, :forceScaleIn => true)
    test "should start restoration" do
      response.body['operationName'].eql?('restore-backup')
    end
    Fog::OracleCloud[:java].instances.get(test_service_name).wait_for(1800) { ready? }
    Fog::OracleCloud[:java].instances.get(test_service_name).ready?
  
    restorations = instance.restorations  
    test "returns an Array" do    
      restorations.is_a? Array
    end  
    test "should return records" do
      restorations.size >= 1
    end 
    
    restoration = restorations.get(test_service_name,restorations.first.job_id)
    test "should return a restoration" do
      restoration.status.is_a? String
    end 

	end

=begin
	tests("#java-delete", "create") do
		instance = Fog::OracleCloud[:java].instances.get('TestWLS')
		instance.dba_name = 'Admin',
		instance.dba_password = 'password'
		instance.destroy()
		instance.wait_for { stopping? }
		tests("should actually delete instance").raises(Fog::OracleCloud::Java::NotFound) do
			instance.wait_for { stopped? } 
		end
	end
=end

end