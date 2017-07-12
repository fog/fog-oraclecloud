require 'active_support/hash_with_indifferent_access'

module Fog
  module Compute
    class OracleCloud
      class Real
      	def update_ip_reservation (params) 
          params[:name].sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          params[:name] = "/Compute-#{@identity_domain}/#{@username}/#{params[:name]}"
          params = params.reject {|key, value| value.nil?}
          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/ip/reservation#{params[:name]}",
            :body     => Fog::JSON.encode(params),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
      
      class Mock
        def update_ip_reservation (params)
          response = Excon::Response.new
          clean_name = params[:name].sub "/Compute-#{@identity_domain}/#{@username}/", ''
          
          ip = self.data[:ip_reservations][clean_name].merge!(params.stringify_keys)
          if !ip['permanent'] && !ip['used'] then
            # An unused IP reservation that is no longer permanent will be deleted
            self.data[:ip_reservations].delete(clean_name)
          end

          response.status = 200
          response.body = ip
          response
        end
      end
    end
  end
end
