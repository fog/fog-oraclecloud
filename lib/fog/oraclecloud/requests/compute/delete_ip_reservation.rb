module Fog
  module Compute
    class OracleCloud
      class Real
      	def delete_ip_reservation (name)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          request(
            :method   => 'DELETE',
            :expects  => 204,
            :path     => "/ip/reservation/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end

      class Mock
        def delete_ip_reservation(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''
          self.data[:ip_reservations].delete(clean_name)
          response.status = 204
          response
        end
      end
    end
  end
end
