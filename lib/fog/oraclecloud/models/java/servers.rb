require 'fog/core/collection'

module Fog
  module OracleCloud
    class Java
      class Servers < Fog::Collection

        model Fog::OracleCloud::Java::Server

        def all(service_name)
          data = service.list_servers(service_name).body['servers']
          data.each { |s| s['service_name'] = service_name }
          load(data)
        end

        def get(service_name, server_name)
          data = service.get_server(service_name, server_name).body
          data['service_name'] = service_name
          new(data)
        end

      end
    end
  end
end
