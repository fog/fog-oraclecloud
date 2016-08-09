module Fog
  module Oracle
    class Java
      class Real
      	def list_instances
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}?outputLevel=verbose"
          )
          response
        end
      end
    end
  end
end
