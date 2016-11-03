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
		instance = Fog::OracleCloud[:java].instances.get('TestWLS')

		test "should return an instance" do
			instance.service_name.is_a? String
			instance.ready?
		end

		test "scale out a cluster" do
			data = instance.scale_out_a_cluster('testcluster',true)
			data['status']  == "New"
			instance.wait_for { ready? }
			instance.ready?
		end

		test "scale in a cluster" do
			data = instance.scale_in_a_cluster('TestWLS_server_4')
			data['status'] == "New"
			instance.wait_for { ready? }
			instance.ready?
		end

		test "scale a node" do
			data = instance.scale_a_node('TestWLS_server_4','oc4')
			data['status'] == "New"
			instance.wait_for { ready? }
			instance.ready?
		end
	end

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
end