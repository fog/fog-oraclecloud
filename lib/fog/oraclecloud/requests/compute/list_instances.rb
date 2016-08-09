module Fog
  module Compute
    class Oracle
      class Real
      	def list_instances
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/instance/Compute-#{@identity_domain}/"
          )
          response
        end
      end
    end
  end
end
