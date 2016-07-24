module Fog
  module Storage
    class Oracle
      class Real
      	def get_container(name)
          response = request(
            :expects  => [204],
            :method   => 'HEAD',
            :path     => "/v1/Storage-#{@identity_domain}/#{name}"
          )
          response
        end
        def get_container_with_objects(name)
          response = request(
            :expects  => [204,200],
            :method   => 'GET',
            :path     => "/v1/Storage-#{@identity_domain}/#{name}?format=json"
          )
          response
        end
      end
    end
  end
end
