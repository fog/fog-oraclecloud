module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_security_list(name, description, policy, outbound_policy)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          body_data     = {
            'name'                => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'description'         => description,
            'policy'              => policy,
            'outbound_cidr_policy'=> outbound_policy
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/seclist/",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )

      	end
      end

      class Mock
        def create_security_list(name, description, policy, outbound_policy)
          response = Excon::Response.new
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          data = {
            'name'                => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'description'         => description,
            'policy'              => policy,
            'outbound_cidr_policy'=> outbound_policy,
            'uri'                 => "#{@api_endpoint}seclist/#{name}"
          }
          self.data[:security_lists][name] = data

          response.status = 201
          response.body = self.data[:security_lists][name]
          response
        end
      end
    end
  end
end
