require 'fog/core/collection'

module Fog
  module OracleCloud
    class SOA
      class Instances < Fog::Collection

      	model Fog::OracleCloud::SOA::Instance

      	def all
          data = service.list_instances().body['services']
          load(data)
        end

        def get(id)
          begin
            new(service.get_instance(id).body)
          rescue Fog::OracleCloud::SOA::NotFound
            nil
          end
        end
      end
    end
  end
end
