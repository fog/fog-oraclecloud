module Fog
  module Oracle
    class Database
      class Real

        def delete_instance(service_name)
          request(
            :method   => 'DELETE',
            :expects  => 202,
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{service_name}"
          )
        end
      end

      class Mock
        def delete_instance(service_name)
          response = Excon::Response.new
            # remove from memoreeeez.
          self.data[:instances].delete service_name
          response.body = { 
            'service_name' => service_name,
            'status' => 'Terminating' 
          }
          response.status = 202
      
          response
        end
      end
    end
  end
end
