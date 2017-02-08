require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | compute requests', 'compute') do
	ip_name = "Test_IP_Reservation_#{Random.rand(100)}"
	tests("#ip-reservations-create", "create") do
		new_ip = Fog::Compute[:oraclecloud].ip_reservations.create(
			:name=>ip_name
		)
		test "can create an ip reservation" do
			new_ip.is_a? Fog::Compute::OracleCloud::IpReservation
			new_ip.name == ip_name
			new_ip.permanent == true
		end


		test "can update tags" do
			new_ip.tags = ['test']
			new_ip.save
			check = Fog::Compute[:oraclecloud].ip_reservations.get(ip_name)
			check.tags == ['test']
		end
	end


	tests("#ip_reservations-read") do
		ips = Fog::Compute[:oraclecloud].ip_reservations.all
		test "returns ip reservations" do
			ips.is_a? Array
			ips.size >= 1
			ips.first.is_a? Fog::Compute::OracleCloud::IpReservation
			ips.first.name.is_a? String
		end

		test "gets a single ip reservation" do
			ip = Fog::Compute[:oraclecloud].ip_reservations.get(ips.first.name)
			ip.is_a? Fog::Compute::OracleCloud::IpReservation
		end
	end

	tests("#ip-reservations-delete", "create") do
		new_ip = Fog::Compute[:oraclecloud].ip_reservations.get(ip_name)

		tests("can update permanent").raises(Fog::Compute::OracleCloud::NotFound) do
			new_ip.permanent = false
			new_ip.save
			# This will actually delete the reservation as it's not attached to an instance
			rule = Fog::Compute[:oraclecloud].ip_reservations.get(ip_name)
		end
		# Create another, since it will be removed in the previous test
		ip = Fog::Compute[:oraclecloud].ip_reservations.create(
			:name=>ip_name
		)
		ip.destroy
		tests("should delete ip reservation").raises(Fog::Compute::OracleCloud::NotFound) do
			rule = Fog::Compute[:oraclecloud].ip_reservations.get(ip_name)
		end
	end
end