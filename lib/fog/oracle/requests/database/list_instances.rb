module Fog
  module Oracle
    class Database
      class Real
      	def list_instances
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}?outputLevel=verbose"
          )
          response
        end
      end
    end
  end
end
