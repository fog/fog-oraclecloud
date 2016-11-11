module Fog
  module OracleCloud
    class Java
      class Real

      	def scale_in_a_cluster(service_name, server_name)

          path = "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/servers/#{server_name}"

 		  response = request(
            :expects  => 202,
            :method   => 'DELETE',
            :path     => path
          )
          response
        end
      end

      class Mock
        def scale_in_a_cluster(service_name, server_name)
      	  response = Excon::Response.new

          response.status = 202
          response.body = {
            "status" => "New", 
            "details" => {
              "message" => "JAAS-SCALING-044: Scaling in Job (ID: 20) server name [ExampleI_server_4] submitted for service [ExampleInstance]", 
              "jobId" => "20"
            }
          }
          response
      	end
      end
    end
  end
end