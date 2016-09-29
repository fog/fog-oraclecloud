require 'pp'

Shindo.tests('Fog::Database[oraclecloud] | database requests', 'database') do
	
	tests("#database-create", "create") do
		db = Fog::OracleCloud[:database].instances.create(
			:service_name => 'TestDB',
			:description => 'A new database',
			:edition => 'SE',
			:vmPublicKey => 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlDbUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ==',
			:shape => 'oc3',
			:version => '12.1.0.2'
		)
		test "can create a database" do
			db.is_a? Fog::OracleCloud::Database::Instance
		end	

		test "is being built" do
			!db.ready?
		end
		db.wait_for { ready? }

		test "is built" do
			db.ready?
		end
	end

	tests('#database-read') do
		instances = Fog::OracleCloud[:database].instances
		test "returns an Array" do
			instances.is_a? Array
		end
	
		test "should return records" do
			instances.size >= 1
		end

		test "should return a valid name" do
			instances.first.service_name.is_a? String
		end

		instance = Fog::OracleCloud[:database].instances.get(instances.first.service_name)
		test "should return an instance" do
			instance.service_name.is_a? String
		end
	end

	tests("#database-delete", "create") do
		db = Fog::OracleCloud[:database].instances.get('TestDB')
		db.destroy()
		db.wait_for { stopping? }
		tests("should actually delete instance").raises(Fog::OracleCloud::Database::NotFound) do
			db.wait_for { stopped? } 
		end
	end
end