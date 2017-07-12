module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_security_association(name, seclist, vcable)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          seclist.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          body_data     = {
            'name'              => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'seclist'           => "/Compute-#{@identity_domain}/#{@username}/#{seclist}",
            'vcable'					  => vcable
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/secassociation/",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
      class Mock
        def create_security_association(name, seclist, vcable)
          response = Excon::Response.new
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          seclist.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

          data = {
            'name'                => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'seclist'             => "/Compute-#{@identity_domain}/#{@username}/#{seclist}",
            'vcable'              => vcable,
            'uri'                 => "#{@api_endpoint}secassociation/#{name}"
          }
          self.data[:security_associations][name] = data

          response.status = 201
          response.body = self.data[:security_associations][name]
          response
        end
      end
    end
  end
end
