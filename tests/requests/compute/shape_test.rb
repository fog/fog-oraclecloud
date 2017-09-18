require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | compute requests', 'compute') do
	tests("#shapes-read") do
		shapes = Fog::Compute[:oraclecloud].shapes.all
		test "returns shapes" do
			shapes.is_a? Array
		end

		if shapes.size >= 1
			test "list returns a valid shape" do
				shapes.first.is_a? Fog::Compute::OracleCloud::Shape
				shapes.first.name.is_a? String
			end
			test "gets a single shape" do
				ip = Fog::Compute[:oraclecloud].shapes.get(shapes.first.name)
				ip.is_a? Fog::Compute::OracleCloud::Shape
			end
		end
	end
end