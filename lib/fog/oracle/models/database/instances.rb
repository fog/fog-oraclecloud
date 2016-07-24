require 'fog/core/collection'
require 'fog/oracle/models/database/instance'

module Fog
  module Oracle
    class Database
      class Instances < Fog::Collection

      	model Fog::Oracle::Database::Instance

      	def all
          data = service.list_instances().body['services']
          load(data)
        end

        def get(id)
          begin
            new(service.get_instance(id).body)
          rescue Fog::Oracle::Database::NotFound
            nil
          end
        end

      end
    end
  end
end
