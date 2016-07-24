require 'pp'

Shindo.tests('Fog::Database[oracle] | database requests', 'database') do
	
	#tests("#java-create", "create") do
	#	sshkey = Fog::Compute[:oracle].ssh_keys.first.name
	#	new_instance = Fog::Compute[:oracle].instances.create(
	#		:name=>'Test123', 
	#		:shape=>'oc3', 
	#		:imagelist=>'/oracle/public/oel_6.4_2GB_v1',
	#		:label=>'dev-vm',
	#		:sshkeys=>[sshkey]
	#	)
	#	test "can create an instance" do
	#		new_instance.is_a? Fog::Compute::Oracle::Instance
	#	end
	#	test "is being built" do
	#		new_instance.state != "running"
	#	end
	#	new_instance.wait_for { ready? }
#
	#	test "is built" do
	#		new_instance.state == 'running'
	#	end
#
	#	new_instance.destroy()
	#	test "can delete instance" do
	#		check = Fog::Compute[:oracle].instances.get(new_instance.name)
	#		check.state == 'stopping'
	#	end
	#end

	tests('#database-read') do
		instances = Fog::Oracle[:database].instances
		test "returns an Array" do
			instances.is_a? Array
		end
	
		test "should return records" do
			instances.size >= 1
		end

		test "should return a valid name" do
			instances.first.service_name.is_a? String
		end

		instance = Fog::Oracle[:database].instances.get(instances.first.service_name)
		test "should return an instance" do
			instance.service_name.is_a? String
		end
	end
end