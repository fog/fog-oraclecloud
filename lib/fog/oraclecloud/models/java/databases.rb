require 'fog/core/collection'

module Fog
  module OracleCloud
    class Java
      class Databases < Fog::Collection

        model Fog::OracleCloud::Java::Database

        def all(service_name)
        #  data = service.list_databases(service_name).body['servers']
        #  load(data)
        end
      end
    end
  end
end
