require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | storage attachments', 'compute') do

	tests("#storage-attachment-create", "create") do
		new_sa = Fog::Compute[:oraclecloud].storage_attachments.create(
			:index => 1,
			:instance_name => 'dsfsf',
			:storage_volume_name => 'dfsf'
		)
		test "can create a storage attachment" do
			new_sa.is_a? Fog::Compute::OracleCloud::StorageAttachment
			pp new_sa
			#new_ip.ip_address_prefix == '192.168.0.0/16'
		end
	end

	tests("#storage-attachment-read") do
		sas = Fog::Compute[:oraclecloud].storage_attachments.all
		test "returns storage attachmentds" do
			sas.is_a? Array
		end
		if sas.size >= 1
			test "list returns a valid storage attachment" do
				sas.first.is_a? Fog::Compute::OracleCloud::StorageAttachment
				sas.first.name.is_a? String
			end
			test "gets a single storage attachment" do
				sa = Fog::Compute[:oraclecloud].storage_attachments.get(sas.first.name)
				sa.is_a? Fog::Compute::OracleCloud::StorageAttachment
			end
		end
	end

	#tests("#storage-attachment-delete", "create") do
	#	ip = Fog::Compute[:oraclecloud].ip_networks.get(ip_name)
	#	ip.destroy
	#	tests("should delete ip network").raises(Fog::Compute::OracleCloud::NotFound) do
	#		check = Fog::Compute[:oraclecloud].ip_networks.get(ip_name)
	#	end
	#end
end