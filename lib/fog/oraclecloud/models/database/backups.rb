require 'fog/core/collection'

module Fog
  module OracleCloud
    class Database
      class Backups < Fog::Collection

        model Fog::OracleCloud::Database::Backup

        def all(db_name)
          data = service.list_backups(db_name).body['backupList']
          load(data)
        end

        # There is no get service for backups in the Oracle Cloud
        # Call the list and extract the backup given a tag
        def get(db_name, tag)
          data = {}
          service.list_backups(db_name).body['backupList'].each { |b| 
            if b['dbTag'] == tag then
              data = b
            end
          }
          new(data)
        end

      end
    end
  end
end
