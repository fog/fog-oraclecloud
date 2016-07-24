module Fog
  module Storage
    class Oracle
      class Objects < Fog::Collection

        attribute :container

      	model Fog::Storage::Oracle::Object

      	def all
          requires :container
          objects = service.get_container_with_objects(container.name)
          load(objects.body)
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
