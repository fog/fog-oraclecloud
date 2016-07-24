require 'fog/core/collection'
require 'fog/oracle/models/java/instance'

module Fog
  module Oracle
    class Java
      class Instances < Fog::Collection

      	model Fog::Oracle::Java::Instance

      	def all
          data = service.list_instances().body['services']
          load(data)
        end

        def get(service_name)
        	begin
            new(service.get_instance(service_name).body)
          rescue Fog::Oracle::Java::NotFound
            nil
          end
        end

      end
    end

  end
end
