module Fog
  module OracleCloud
    class Java
      class Real

      	def scale_out_a_cluster(service_name, cluster_name, create_cluster_if_missing)

          path = "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/servers/#{cluster_name}"
          if create_cluster_if_missing then
            path = "#{path}?createClusterIfMissing=true"
          end

 		      response = request(
            :expects  => 202,
            :method   => 'POST',
            :path     => path
          )
          response
        end
      end

      class Mock
        def scale_out_a_cluster(service_name, cluster_name, create_cluster_if_missing)
      		response = Excon::Response.new

          response.status = 202
          response.body = {
            "status" => "New", 
            "details" => {
              "message" => "JASS-SCALING-037: Scale out Job (ID: 17) for service [ExampleInstance] in cluster [ExampleI_cluster] submitted", 
              "jobId" => "17"
            }
          }
          response
      	end
      end
    end
  end
end