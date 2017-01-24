require 'fog/core/collection'

module Fog
  module OracleCloud
    class Java
      class AccessRules < Fog::Collection
        attribute :instance

        model Fog::OracleCloud::Java::AccessRule

        def all
          data = service.list_access_rules(instance.service_name).body['accessRules']
          load(data)
        end

        def get(rule_name)
          data = service.list_access_rules(instance.service_name).body['accessRules']
          rule = load(data).detect { |r| r.rule_name === rule_name }
          if !rule.nil?
            rule
          else
            raise Fog::OracleCloud::Java::NotFound.new("Access Rule #{rule_name} does not exist");
          end
        end

        def new(attributes = {})
          super({:service_name=>instance.service_name}.merge!(attributes))
        end
      end
    end
  end
end
