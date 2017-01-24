module Fog
  module OracleCloud
    class Java
      class Real

        def enable_access_rule(service_name, rule_name)
          body_data = {
            'operation'=> 'update',
            'status' => 'enabled'
          }

          request(
            :method   => 'PUT',
            :expects  => 200,
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/jaas/instances/#{service_name}/accessrules/#{rule_name}",
            :body     => Fog::JSON.encode(body_data)
          )
        end
      end

      class Mock
        def enable_access_rule(service_name, rule_name)
          response = Excon::Response.new
          rule = self.data[:access_rules][service_name].detect { |r| r['ruleName'] === rule_name }
          rule['status'] = 'enabled'
          response.body = rule
          response.status = 200
          response
        end
      end
    end
  end
end
