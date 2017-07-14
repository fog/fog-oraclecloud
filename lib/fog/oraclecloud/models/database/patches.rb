require 'fog/core/collection'

module Fog
  module OracleCloud
    class Database
      class Patches < Fog::Collection

        model Fog::OracleCloud::Database::Patch

        def all(db_name)
          data = service.list_patches(db_name).body
          load(data)
        end

      end
    end
  end
end
