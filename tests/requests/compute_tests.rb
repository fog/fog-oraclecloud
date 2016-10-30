require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | compute requests', 'compute') do
	tests("#image_lists") do
		images = Fog::Compute[:oraclecloud].image_lists.all
		test "get image list" do
			images.is_a? Array
		end
	end
end