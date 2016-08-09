require 'fog/core/collection'

module Fog
  module OracleCloud
    class Java
      class Instances < Fog::Collection

      	model Fog::OracleCloud::Java::Instance

      	def all
          data = service.list_instances().body['services']
          load(data)
        end

        def get(service_name)
        	begin
            new(service.get_instance(service_name).body)
          rescue Fog::OracleCloud::Java::NotFound
            nil
          end
        end

      end
    end

  end
end
