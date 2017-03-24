require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | compute requests', 'compute') do
	ip_name = "ipnet#{Random.rand(100)}"
	tests("#ip-network-create", "create") do
		new_ip = Fog::Compute[:oraclecloud].ip_networks.create(
			:ip_address_prefix=>"192.168.0.0/16",
			:name => ip_name
		)
		test "can create an ip network" do
			new_ip.is_a? Fog::Compute::OracleCloud::IpNetwork
			new_ip.name == ip_name
			new_ip.ip_address_prefix == '192.168.0.0/16'
		end
	end

	tests("#ip_networks-read") do
		ips = Fog::Compute[:oraclecloud].ip_networks.all
		test "returns ip networks" do
			ips.is_a? Array
		end

		if ips.size >= 1
			test "list returns a valid ip network" do
				ips.first.is_a? Fog::Compute::OracleCloud::IpNetwork
				ips.first.name.is_a? String
			end
			test "gets a single ip network" do
				ip = Fog::Compute[:oraclecloud].ip_networks.get(ips.first.name)
				ip.is_a? Fog::Compute::OracleCloud::IpNetwork
			end
		end
	end

	tests("#ip-reservations-delete", "create") do
		ip = Fog::Compute[:oraclecloud].ip_networks.get(ip_name)
		ip.destroy
		tests("should delete ip network").raises(Fog::Compute::OracleCloud::NotFound) do
			check = Fog::Compute[:oraclecloud].ip_networks.get(ip_name)
		end
	end
end