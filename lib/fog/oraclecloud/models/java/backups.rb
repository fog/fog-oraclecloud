require 'fog/core/collection'

module Fog
  module OracleCloud
    class Java
      class Backups < Fog::Collection

        model Fog::OracleCloud::Java::Backup

        def all(service_name)
          data = service.list_backups(service_name).body['backups']
          load(data)
        end

        def get(service_name, backup_id)
          data = service.get_backup(service_name, backup_id).body         
          data['service_name'] = service_name          
          new(data)
        end

      end
    end
  end
end
