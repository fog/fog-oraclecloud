module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_ip_reservation (params)
          if !params[:name].nil? && !params[:name].start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            params[:name] = "/Compute-#{@identity_domain}/#{@username}/#{params[:name]}"
          end            

          params = params.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/ip/reservation/",
            :body     => Fog::JSON.encode(params),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end

      class Mock
        def create_ip_reservation (params)
          response = Excon::Response.new
          name = params[:name]
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          self.data[:ip_reservations][name] = {
            'name' => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'account' => "/Compute-#{@identity_domain}/#{@username}",
            'used' => false,
            'tags' => params[:tags] || [],
            'ip' => '123.123.123.56',
            'uri' => "#{@api_endpoint}ip/reservation/Compute-#{@identity_domain}/#{@username}/#{name}",
            'quota' => nil,
            'parentpool' => params[:parentpool],
            'permanent' => params[:permanent]
          }
          response.status = 201
          response.body = self.data[:ip_reservations][name]
          response
        end
      end
    end
  end
end
