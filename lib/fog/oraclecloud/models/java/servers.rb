require 'fog/core/collection'
require 'fog/oracle/models/java/server'


module Fog
  module Oracle
    class Java
      class Servers < Fog::Collection

        model Fog::Oracle::Java::Server

        def all(service_name)
          data = service.list_servers(service_name).body['servers']
          load(data)
        end
      end
    end
  end
end
