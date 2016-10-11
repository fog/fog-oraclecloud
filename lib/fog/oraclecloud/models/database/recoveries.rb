require 'fog/core/collection'

module Fog
  module OracleCloud
    class Database
      class Recoveries < Fog::Collection

        model Fog::OracleCloud::Database::Recovery

        def all(db_name)
          data = service.list_recoveries(db_name).body['recoveryList']
          load(data)
        end

        # There is no get service for recoveries in the Oracle Cloud
        # Call the list and extract the recovery 
        def get(db_name, type=nil, value=nil)
          clean_type = 'dbTag' if type == 'tag'
          clean_type, value = ['latest', true] if type.nil?
          data = service.list_recoveries(db_name).body['recoveryList'].find { |r| r[clean_type] == value }
          new(data)
        end
      end
    end
  end
end
