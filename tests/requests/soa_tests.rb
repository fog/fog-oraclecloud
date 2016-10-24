require 'pp'

Shindo.tests('Fog::Soa[oraclecloud] | SOA requests', 'soa') do
	
	tests("#soa-create", "create") do
		instance = Fog::OracleCloud[:soa].instances.create(
			:service_name => 'TestSOA',
			:description => 'A new weblogic instance',
			:dba_name => 'SYS',
			:dba_password => 'password',
			:db_service_name => 'TestDB',
			:admin_password => 'Welcome1$',
			:admin_username => 'weblogic',
			:shape => 'oc3m',
			:version => '12.2.1',
			:ssh_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlinstanceUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ==',
			:cloud_storage_container => 'Test123',
			:topology => 'osb'			
		)
		test "can create a soa instance" do
			instance.is_a? Fog::OracleCloud::SOA::Instance
		end	

		test "is being built" do
			!instance.ready?
		end
		instance.wait_for { ready? }

		test "is built" do
			instance.ready?
		end
	end

	tests("#soa-and-db-create", "create") do
		instance = Fog::OracleCloud[:soa].instances.create({
			:service_name => 'TestSOA2',
			:description => 'A new weblogic instance',
			:admin_password => 'Welcome1$',
			:admin_username => 'weblogic',
			:shape => 'oc3m',
			:version => '12.2.1',
			:ssh_key => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlinstanceUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ==',
			:topology => 'osb'			
		})
		test "can create a soa instance" do
			instance.is_a? Fog::OracleCloud::SOA::Instance
		end	

		test "is being built" do
			!instance.ready?
		end
		instance.wait_for { ready? }

		test "is built" do
			instance.ready?
		end

		test "shoud have created a database instance" do
			db = Fog::OracleCloud[:database].instances.get('TestSOA2-DB')
			db.is_a? Fog::OracleCloud::Database::Instance
		end

		test "should have created a storage container" do
			container = Fog::Storage[:oraclecloud].containers.get('TestSOA2_Backup')
			container.is_a? Fog::Storage::OracleCloud::Container
		end
	end

	tests('#soa-validation') do
		tests("should ensure service name doesn't have underscore").raises(ArgumentError) do
			instance = Fog::OracleCloud[:soa].instances.new({
				:service_name => 'Has_Underscore'
				})
		end
		tests("should ensure service name doesn't have number as first letter").raises(ArgumentError) do
			instance = Fog::OracleCloud[:soa].instances.new({
				:service_name => '1NotFirstLetter'
				})
		end
		tests("should ensure service name isn't too long").raises(ArgumentError) do
			instance = Fog::OracleCloud[:soa].instances.new({
				:service_name => 'ReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyReallyLongName'
				})
		end
		tests("should ensure service name doesn't contain special characters").raises(ArgumentError) do
			instance = Fog::OracleCloud[:soa].instances.new({
				:service_name => 'Special$characters'
				})
		end
		tests("should ensure admin password starts with a letter").raises(ArgumentError) do
			instance = Fog::OracleCloud[:soa].instances.new({
				:service_name => 'Test',
				:admin_password => '1NotFirstLetter'
				})
		end
		tests("should ensure admin password is not too long").raises(ArgumentError) do
			instance = Fog::OracleCloud[:soa].instances.new({
				:service_name => 'Test',
				:admin_password => 'ReallyReallyReallyReallyReallyReallyReallyReallyPassword1$'
				})
		end
		tests("should ensure admin password has special chars").raises(ArgumentError) do
			instance = Fog::OracleCloud[:soa].instances.new({
				:service_name => 'Test',
				:admin_password => 'WelcomePassword1'
				})
		end
		tests("should ensure admin password has numbers").raises(ArgumentError) do
			instance = Fog::OracleCloud[:soa].instances.new({
				:service_name => 'Test',
				:admin_password => 'WelcomePassword$'
				})
		end
	end

	tests('#soa-read') do
		instances = Fog::OracleCloud[:soa].instances
		test "returns an Array" do
			instances.is_a? Array
		end
	
		test "should return records" do
			instances.size >= 1
		end

		test "should return a valid name" do
			instances.first.service_name.is_a? String
		end

		instance = Fog::OracleCloud[:soa].instances.get(instances.first.service_name)
		test "should return an instance" do
			instance.service_name.is_a? String
		end

		test "get job status" do
			status = instance.job_status
			status.is_a? Array
		end
	end

	tests("#soa-delete", "create") do
		instance = Fog::OracleCloud[:soa].instances.get('TestSOA')
		instance.destroy('SYS', 'password')
		instance.wait_for { stopping? }
		tests("should actually delete instance").raises(Fog::OracleCloud::SOA::NotFound) do
			instance.wait_for { stopped? } 
		end
		# Clean up
		instance = Fog::OracleCloud[:soa].instances.get('TestSOA2')
		instance.destroy('SYS', 'Welcome1$')
	end
end