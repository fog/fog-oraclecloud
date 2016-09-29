require 'pp'

Shindo.tests('Fog::Java[oraclecloud] | java requests', 'java') do
	
	tests("#database-create", "create") do
		instance = Fog::OracleCloud[:java].instances.create(
			:service_name => 'TestWLS',
			:description => 'A new weblogic instance',
			:cloud_storage_container => 'todo',
			:cloud_storage_user => 'admin',
			:cloud_storage_password => 'password',
			:dbaName => 'SYS',
			:dbaPassword => 'password',
			:dbServiceName => 'TestDB',
			:shape => 'oc3',
			:version => '12.2.1',
			:vmPublicKey => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlinstanceUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ==',
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