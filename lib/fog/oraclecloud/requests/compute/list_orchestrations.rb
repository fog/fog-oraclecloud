module Fog
  module Compute
    class Oracle
      class Real
      	def list_orchestrations
          response = request(
            :expects => 200,
            :method  => 'GET',
            :path    => "/orchestration/Compute-#{@identity_domain}/"
          )
          response
        end
      end
    end
  end
end
