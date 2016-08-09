require 'fog/core/collection'

module Fog
  module OracleCloud
    class Java
      class Servers < Fog::Collection

        model Fog::OracleCloud::Java::Server

        def all(service_name)
          data = service.list_servers(service_name).body['servers']
          load(data)
        end
      end
    end
  end
end
