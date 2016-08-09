module Fog
  module Storage
    class OracleCloud
      class Containers < Fog::Collection

      	model Fog::Storage::OracleCloud::Container

      	def all
          containers = service.list_containers().body
          load(containers)
        end

        def get(name)
          data = service.get_container(name).headers
          # The storage cloud service doesn't actually return the name. Add it back in
          data['name'] = name
          new(data)
        end

      end
    end

  end
end
