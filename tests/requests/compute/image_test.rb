require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | compute requests', 'compute') do
	tests("#images-read") do
		images = Fog::Compute[:oraclecloud].images.all
		test "returns images" do
			images.is_a? Array
		end

		public_images = Fog::Compute[:oraclecloud].images.all_public
		test "returns public images" do
			public_images.is_a? Array
		end

		if public_images.size >= 1
			test "list returns a valid image" do
				public_images.first.is_a? Fog::Compute::OracleCloud::Image
				public_images.first.name.is_a? String
			end
			test "gets a single image" do
				ip = Fog::Compute[:oraclecloud].images.get_public(public_images.first.name)
				ip.is_a? Fog::Compute::OracleCloud::Image
			end
		end
	end
end