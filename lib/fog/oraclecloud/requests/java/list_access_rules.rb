module Fog
  module OracleCloud
    class Java
      class Real
      	def list_access_rules(service_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/jaas/instances/#{service_name}/accessrules"
          )
          response
        end
      end

      class Mock
        def list_access_rules(service_name)
          response = Excon::Response.new

          rules = self.data[:access_rules][service_name]

          response.body =  {
            'accessRules' => rules
          }

          response
        end
      end
    end
  end
end
