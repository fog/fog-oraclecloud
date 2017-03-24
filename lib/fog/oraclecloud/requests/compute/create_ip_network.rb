module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_ip_network (params)
          if !params[:name].nil? && !params[:name].start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            params[:name] = "/Compute-#{@identity_domain}/#{@username}/#{params[:name]}"
          end            

          params = params.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/network/v1/ipnetwork/",
            :body     => Fog::JSON.encode(params),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end

      class Mock
        def create_ip_network (params)
          response = Excon::Response.new
          name = params[:name]
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          self.data[:ip_networks][name] = {
            'name' => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'uri' => "#{@api_endpoint}network/v1/ipnetwork/Compute-#{@identity_domain}/#{@username}/#{name}",
            'description' => nil,
            'tags' => nil,
            'ipAddressPrefix' => params[:ipAddressPrefix],
            'ipNetworkExchange' => params[:ipNetworkExchange],
            'publicNaptEnabledFlag' => false
          }
          response.status = 201
          response.body = self.data[:ip_networks][name]
          response
        end
      end
    end
  end
end
