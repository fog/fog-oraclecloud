module Fog
  module OracleCloud
    class Java
      class Real

        def create_access_rule(service_name, params)
          request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/jaas/instances/#{service_name}/accessrules",
            :body     => Fog::JSON.encode(params)
          )
        end
      end
      class Mock
        def create_access_rule(service_name, params)
          response = Excon::Response.new
          params.delete(:service_name)
          self.data[:access_rules][service_name] << params.collect{|k,v| [k.to_s, v]}.to_h

          response.status = 202
          response
        end
      end
    end
  end
end
