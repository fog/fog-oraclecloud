module Fog
  module OracleCloud
    class Java
      class Real

      	def scale_a_node(service_name, server_name, options={})

          path = "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/#{server_name}"
          body_data     = {
            'shape'             => options[:shape],
            'additionalStorage' => options[:additionalStorage],
            'ignoreManagedServerHeapError' =>  options[:ignoreManagedServerHeapError],
            'scalingVolume'             => options[:scalingVolume]
          }
          body_data = body_data.reject {|key, value| value.nil?}

 		  response = request(
            :expects  => 202,
            :method   => 'PUT',
            :path     => path,
            :body     => Fog::JSON.encode(body_data)
          )
          response
        end
      end

      class Mock
        def scale_a_node(service_name, server_name, options={})
      	  response = Excon::Response.new

          response.status = 202
          response.body = {
            "status" => "New", 
            "details" => {
              "message" => "scaleup.job.submitted", 
              "jobId" => "22"
            }
          }
          response
      	end
      end
    end
  end
end