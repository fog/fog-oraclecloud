module Fog
  module Compute
    class Oracle
      class Real
      	def list_security_lists
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/seclist/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
      end
    end
  end
end
