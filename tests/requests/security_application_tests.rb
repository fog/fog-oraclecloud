require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | security application requests', 'security_applications') do

	

	tests("#secapps-read") do
		secapps = Fog::Compute[:oraclecloud].security_applications.all
		test "returns an Array" do
			secapps.is_a? Array
		end
		test "should return keys" do
			secapps.size >= 1
		end
		test "should return a valid name" do
			secapps.first.name.is_a? String
		end
		#secapps.each do |app| puts app.name end
		test "includes public apps" do

			public_list = secapps.detect { |app| app.name.include? 'oracle/public' }
			public_list.is_a? Fog::Compute::OracleCloud::SecurityApplication
		end

		#secapp = Fog::Compute[:oraclecloud].security_applications.get(secapps.first.name)
		#test "should return a key" do
		#	secapp.name.is_a? String
		#end
	end


end