require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | ip_reservation requests', 'instances') do
	
	tests("#ip-reservation-read") do
		ips = Fog::Compute[:oraclecloud].ip_reservations
		test "returns an Array" do
			ips.is_a? Array
		end
		test "should return keys" do
			ips.size >= 1
		end
		test "should return a valid name" do
			ips.first.name.is_a? String
		end

		ip = Fog::Compute[:oraclecloud].ip_reservations.get(ips.first.name)
		test "should return an instance" do
			ip.name.is_a? String
		end
	end
	
	tests('#ip_reservation from instance') do
		instances = Fog::Compute[:oraclecloud].instances
		instance = instances.detect { |i| i.networking['eth0'] and i.networking['eth0']['nat'] and i.networking['eth0']['nat'].include? 'ipreservation'}
		if instance then
			test "can get public ip address" do
				ip = instance.get_public_ip_address
				ip.is_a? String # TODO: Test for IP address				
			end
		end
	end
end