module Fog
  module OracleCloud
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
        def delete_instance(name)
          response = Excon::Response.new
          self.data[:instances][name]['status'] = 'Terminating'
          self.data[:deleted_at][name] = Time.now
          response.status = 204
          response
        end
      end
    end
  end
end
