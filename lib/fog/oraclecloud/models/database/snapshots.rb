require 'fog/core/collection'

module Fog
  module OracleCloud
    class Database
      class Snapshots < Fog::Collection

        model Fog::OracleCloud::Database::Snapshot

        def all(db_name)
          data = service.list_snapshots(db_name).body
          load(data)
        end
        
        def get(db_name, snapshot_name)
          new(service.get_snapshot(db_name, snapshot_name).body)
        end

      end
    end
  end
end
