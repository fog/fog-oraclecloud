require 'fog/core/collection'

module Fog
  module OracleCloud
    class Database
      class Servers < Fog::Collection

        model Fog::OracleCloud::Database::Server

        def all(db_name)
          data = service.list_servers(db_name).body
          load(data)
        end
        
      end
    end
  end
end
