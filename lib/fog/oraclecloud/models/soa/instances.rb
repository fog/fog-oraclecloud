require 'fog/core/collection'
require 'fog/oracle/models/soa/instance'

module Fog
  module Oracle
    class SOA
      class Instances < Fog::Collection

      	model Fog::Oracle::SOA::Instance

      	def all
          data = service.list_instances().body['services']
          load(data)
        end

        def get(id)
          begin
            new(service.get_instance(id).body)
          rescue Fog::Oracle::SOA::NotFound
            nil
          end
        end
      end
    end
  end
end
