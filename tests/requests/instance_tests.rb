require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | instance requests', 'instances') do
	
	tests("#instance-create", "create") do
		#sshkey = Fog::Compute[:oraclecloud].ssh_keys.first.name
		begin
			sshkey = Fog::Compute[:oraclecloud].ssh_keys.get('Test123Key')
		rescue Fog::Compute::OracleCloud::NotFound
			sshkey = Fog::Compute[:oraclecloud].ssh_keys.create(
				:name 		=> 'TestSSHKey2',
				:enabled 	=> false,
				:key			=> 'ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkNNQ4ri2oUW46mBO/4CHMGCOALciumwGvFEMDLGNnlDbUSqU4IRrqgj+znLClfb29Oer0devdarM6DilsZVgZ2YbI5ZD5vICR/O9J0c28dArwbtFeIjcV2TCWyj5xKEXF1r+OrJMexHQa0fW1URGrU8QODpJNC/9eCVGcEXddL31xTZYpjoVOCVx66kNa6lSHEVV3T4zaCby9Oe5QI4gZe1+xyxHPNEW5wogwS3dlKSyL2CfBP0aUKOmJ5Nrl8+y0GqJQXdGjZ9FIknmwWueRW/6qPQvZocjOZ8YiPZgAP0RNy6lL+u8mnAazj/mrEdmB5QUzpDAllIr5Tn/xaddZQ=='
			)
		end

		new_instance = Fog::Compute[:oraclecloud].instances.create(
			:name=>'Test123', 
			:shape=>'oc3', 
			:imagelist=>'/oracle/public/oel_6.4_2GB_v1',
			:label=>'dev-vm',
			:sshkeys=>[sshkey.name]
		)
		test "can create an instance" do
			new_instance.is_a? Fog::Compute::OracleCloud::Instance
		end
		new_instance.wait_for { ready? }

		test "is built" do
			new_instance.state == 'running'
		end
	end

	tests('#instances-read') do
		instances = Fog::Compute[:oraclecloud].instances
		test "returns an Array" do
			instances.is_a? Array
		end
		instances.each do |ins|
			puts "#{ins.clean_name} - #{ins.state}"
		end
		test "should return records" do
			instances.size >= 1
		end

		test "should return a valid name" do
			instances.first.name.is_a? String
		end

		instance = Fog::Compute[:oraclecloud].instances.get(instances.first.name)
		test "should return an instance" do
			instance.name.is_a? String
		end
	end

	tests("#instance-delete", "create") do
		instance = Fog::Compute[:oraclecloud].instances.get('Test123')
		instance.destroy()
		instance.wait_for { state == 'stopping' }
		tests("should actually delete instance").raises(Fog::Compute::OracleCloud::NotFound) do
			instance.wait_for { state == 'stopped' } 
		end
	end
end