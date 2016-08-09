Shindo.tests('Fog::Storage[oraclecloud] | storage requests', 'storage') do

	tests("#storage-create", "create") do
		container = Fog::Storage[:oraclecloud].containers.create(
			:name 		=> 'TestContainer1',
		)
		test "can create a storage container" do
			container.is_a? Fog::Storage::OracleCloud::Container
			container.name.is_a? String
		end

		check = Fog::Storage[:oraclecloud].containers.get(container.name)
		test "can get container" do
			check.name == container.name
		end

		# Can't destroy immediately, as the cloud won't have replicated in time and will give us an error
		# when we try to delete. No way to find out if the cloud has finished this replication though
	#	container.destroy()
	#	tests("can delete container").raises(Excon::Error::NotFound) do
	#		check = Fog::Storage[:oracle].containers.get(container.name)
	#	end
	end

	tests("#storage-read") do
		containers = Fog::Storage[:oraclecloud].containers
		test "returns an Array" do
			containers.is_a? Array
		end
		test "should return keys" do
			containers.size >= 1
		end
		test "should return a valid name" do
			containers.first.name.is_a? String
		end
		container = Fog::Storage[:oraclecloud].containers.get(containers.first.name)
		test "should return a key" do
			container.name.is_a? String
		end
	end

	tests("#object-read") do
		objects = Fog::Storage[:oraclecloud].containers[5].objects
		test "returns an Array" do
			objects.is_a? Array
		end
		test "should return multiple" do
			objects.size >= 1
		end
		test "should return an object" do
			objects.first.name.is_a? String
		end
	end
end