require 'fog/core/collection'

module Fog
  module OracleCloud
    class Java
      class Restorations < Fog::Collection

        model Fog::OracleCloud::Java::Restoration

        def all(service_name)
          data = service.list_restorations(service_name).body['restoreHistory']
          load(data)
        end

        def get(service_name, job_id)
          data = service.get_restoration(service_name, job_id).body
          data['service_name'] = service_name          
          new(data)
        end

      end
    end
  end
end
