module Fog
  module OracleCloud
    class Java
      class Real

        def delete_access_rule(service_name, rule_name)
          body_data = {
            'operation'=> 'delete'
          }

          request(
            :method   => 'PUT',
            :expects  => 202,
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/jaas/instances/#{service_name}/accessrules/#{rule_name}",
            :body     => Fog::JSON.encode(body_data)
          )
        end
      end

      class Mock
        def delete_access_rule(service_name, rule_name)
          response = Excon::Response.new
          rule = self.data[:access_rules][service_name].detect { |r| r['ruleName'] === rule_name }
          rule['status'] = 'disabled'
          self.data[:access_rules][service_name].delete_if { |r| r['ruleName'] === rule_name }
          response.body = {
            'rule' => rule
          }
          response.status = 202
          response
        end
      end
    end
  end
end
