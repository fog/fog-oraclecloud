module Fog
  module Storage
    class OracleCloud
      class Real
      	def delete_container (name)
          request(
            :method   => 'DELETE',
            :expects  => 204,
            :path     => "/v1/Storage-#{@identity_domain}/#{name}"
          )
      	end
      end
    end
  end
end
