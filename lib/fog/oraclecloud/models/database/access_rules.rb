require 'fog/core/collection'

module Fog
  module OracleCloud
    class Database
      class AccessRules < Fog::Collection

        model Fog::OracleCloud::Database::AccessRule

        def all(db_name)
          data = service.list_access_rules(db_name).body
          load(data)
        end
        
        def get(db_name, access_rule_name)
          new(service.get_access_rule(db_name, access_rule_name).body)
        end

        def create(db_name, attributes = {})
          attributes[:database_id] = db_name
          object = new(attributes)
          object.save
          object
        end
      end
    end
  end
end
