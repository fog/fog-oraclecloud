module Fog
  module Storage
    class Oracle
      class Container < Fog::Model
        identity  :name

        attribute :count, :aliases => 'X-Container-Object-Count'
        attribute :bytes, :aliases => 'X-Container-Bytes-Used'
        attribute :deleteTimestamp
        attribute :containerId
        attribute :read_acl, :aliases => 'X-Container-Read'
        attribute :write_acl, :aliases => 'X-Container-Write'
        attribute :createdTimestamp, :aliases => 'X-Timestamp'

        def objects
          @objects ||= Fog::Storage::Oracle::Objects.new(:container=>self, :service=>service)
        end

        def save
          requires :name
          data = service.create_container(name)
          pp data
          merge_attributes(data.headers)
        end 
        
        def destroy
          requires :name
          service.delete_container(name)
        end

      end
    end
  end
end
