module Fog
  module Compute
    class Oracle
      class Real
      	def list_security_applications
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/secapplication/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
      end

      class Mock
        def list_security_applications
        end
      end
    end
  end
end
