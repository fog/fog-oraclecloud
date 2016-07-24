module Fog
  module Oracle
    class Database
      class Real

      	def get_instance(instance_id)
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{instance_id}"
          )
          response
        end
      end

      class Mock
        def get_instance(instance_id)
          response = Excon::Response.new
          if instance_exists? instance_id
            response.status = 200
            response.body   = self.data[:instances][instance_id]
          else
            raise Fog::Oracle::Database::NotFound
          end
          response
        end

        # Checks if an instance exists
        def instance_exists?(instance_id)
          self.data[:instances].key? instance_id
        end
        
      end
    end
  end
end