module Fog
  module OracleCloud
    class Database
      class Real

      	def get_access_rule(db_name, rule_name)
          # There isn't actually an API for this. So just get all of them and find the one they wanted
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/dbaas/instances/#{db_name}/accessrules"
          )
          rule = response.body["accessRules"].detect { |r| r['ruleName'] == rule_name}
          if rule.nil? then
            raise Fog::OracleCloud::Database::NotFound.new("Could not find rule (#{rule_name}) attached to #{db_name}")
          end
          response.body = rule
          response
        end
      end

      class Mock
        def get_access_rule(db_name, rule_name)
          response = Excon::Response.new

          rule = self.data[:access_rules][db_name].detect { |r| r['ruleName'] == rule_name}

          if !rule.nil? then
            response.status = 200
            response.body = rule
            response
          else
            raise Fog::OracleCloud::Database::NotFound.new("Rule #{rule_name} for #{db_name} does not exist");
          end
        end
      end
    end
  end
end