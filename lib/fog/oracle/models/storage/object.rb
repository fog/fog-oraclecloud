module Fog
  module Storage
    class Oracle
      class Object < Fog::Model
        identity  :name

        attribute :content_type
        attribute :bytes
        attribute :last_modified
        attribute :hash

        def save
          requires :name
        #  data = service.create_container(name)
         # pp data
         # merge_attributes(data.headers)
        end 
        
        def destroy
          requires :name
        #  service.delete_container(name)
        end

      end
    end
  end
end
