module Fog
  module Storage
    class Oracle
      class Real

      	def create_container(name)
          request({
            :method   => 'PUT',
            :expects  => [201,202],
            :path     => "/v1/Storage-#{@identity_domain}/#{name}"
          }, false)
        end

      end

      class Mock
      	
      end
    end
  end
end
