require 'pp'

Shindo.tests('Fog::Compute[oraclecloud] | orchestration requests', 'orchestrations') do
	
	tests("#orchestrations-create", "create") do
		orchestration = Fog::Compute[:oraclecloud].orchestrations.create(
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
			orchestration.is_a? Fog::Compute::OracleCloud::Orchestration
		end

		check = Fog::Compute[:oraclecloud].orchestrations.get(orchestration.name)
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
		orchestration.wait_for { ready? }
		test "can update orchestration" do
			check = Fog::Compute[:oraclecloud].orchestrations.get(orchestration.name)
			check.oplans.size == 2
		end

		orchestration.start()
		orchestration.wait_for { running? }
		test "can start" do
			orchestration.status == 'running'
		end
		orchestration.stop()
		orchestration.wait_for { stopped? }
		test "can stop" do
			orchestration.status == 'stopped'
		end

		orchestration.destroy()
		tests("can delete orchestration").raises(Excon::Error::NotFound) do
			check = Fog::Compute[:oraclecloud].orchestrations.get(orchestration.name)
		end
	end

	tests("#orchestrations-read") do
		orchestrations = Fog::Compute[:oraclecloud].orchestrations
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

		orchestrations = Fog::Compute[:oraclecloud].orchestrations.get(orchestrations.first.name)
		test "should return a key" do
			orchestrations.name.is_a? String
		end
	end
end