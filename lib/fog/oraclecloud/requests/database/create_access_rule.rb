module Fog
  module OracleCloud
    class Database
      class Real

      	def create_access_rule(service_name, name, description, ports, source, destination, status)
          body_data     = {
            'ruleName' => name,
            'description' => description,
            'destination' => destination,
            'ports' => ports,
            'source' => source,
            'status' => status
          }
          response = request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/dbaas/instances/#{service_name}/accessrules",
            :body     => Fog::JSON.encode(body_data),
          )
          response
        end
      end

      class Mock
        def create_access_rule(service_name, name, description, ports, source, destination, status)
          response = Excon::Response.new

          data = {
            'ruleName' => name,
            'description' => description,
            'status' => status,
            'source' => source,
            'destination'=>destination,
            'ports'=>ports,
            'ruleType'=>'USER',
            'database_id'=>service_name
          }
          if !self.data[:access_rules].key?(service_name) then self.data[:access_rules][service_name] = {} end
          self.data[:access_rules][service_name][name] = data
          response.status = 202
          response
        end
      end
    end
  end
end
