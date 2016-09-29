require 'fog/core/collection'

module Fog
  module OracleCloud
    class Database
      class Instances < Fog::Collection

      	model Fog::OracleCloud::Database::Instance

      	def all
          data = service.list_instances().body['services']
          load(data)
        end

        def get(id)
          new(service.get_instance(id).body)
        end

      end
    end
  end
end
