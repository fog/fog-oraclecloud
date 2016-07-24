require 'pp'

Shindo.tests('Fog::Compute[oracle] | orchestration requests', 'orchestrations') do
	
	tests("#orchestrations-create", "create") do
		orchestration = Fog::Compute[:oracle].orchestrations.create(
			:name => "OrchestrationTest-#{rand(100)}",
			:oplans => [{
				'label' =>"WebServer",
				'obj_type' => "launchplan",
				'objects' => [{
					'instances' =>[{
						'shape' => 'oc3',
						'label' => "vm-1",
						'imagelist' =>'/oracle/public/oel_6.4_2GB_v1',
						'name' => "WebServer"
					}]
				}]
			}]
		)
		test "can create an orchestration" do
			orchestration.is_a? Fog::Compute::Oracle::Orchestration
		end

		check = Fog::Compute[:oracle].orchestrations.get(orchestration.name)
		test "can get created orchestration" do
			check.uri == orchestration.uri
		end

		orchestration.oplans << {
			'label' => "Database Server",
			'obj_type' => "launchplan",
			'objects' => [{
				'instances' => [{
					'shape' => 'oc3',
					'label' => 'vm-2',
					'imagelist' => '/oracle/public/oel_6.4_2GB_v1',
					'name' => 'DatabaseServer'
				}]
			}]
		}
		orchestration.save()
		test "can update orchestration" do
			check = Fog::Compute[:oracle].orchestrations.get(orchestration.name)
			check.oplans.size == 2
		end

		orchestration.destroy()
		tests("can delete orchestration").raises(Excon::Error::NotFound) do
			check = Fog::Compute[:oracle].orchestrations.get(orchestration.name)
		end
	end

	tests("#orchestrations-read") do
		orchestrations = Fog::Compute[:oracle].orchestrations
		test "returns an Array" do
			orchestrations.is_a? Array
		end
		orchestrations.each do |orch|
			puts orch.name
		end
		test "should return keys" do
			orchestrations.size >= 1
		end
		test "should return a valid name" do
			orchestrations.first.name.is_a? String
		end

		orchestrations = Fog::Compute[:oracle].orchestrations.get(orchestrations.first.name)
		test "should return a key" do
			orchestrations.name.is_a? String
		end
	end
end