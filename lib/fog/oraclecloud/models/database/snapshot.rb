require 'fog/core/model'

module Fog
  module OracleCloud
    class Database
      class Snapshot < Fog::Model
        identity  :name

        attribute :cloned_services_size,  :aliases=>'clonedServicesSize'
        attribute :creation_time,  :aliases=>'creationTime'
        attribute :cloned_services,  :aliases=>'clonedServices'
        attribute :status
        attribute :description

        attribute :database_id
       
        def completed?
          status == "Succeeded"
        end

        def deleting?
          status == "Terminating"
        end
 
        def save
          create
        end

        def destroy
          requires :name, :database_id
          service.delete_snapshot(database_id, name).body
        end

        # Had to override snapshot as we need to pass the database_id
        def reload
          requires :identity, :database_id

          data = begin
            collection.get(database_id, identity)
          rescue Excon::Errors::SocketError
            nil
          end

          return unless data

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end

        private

        def create
          requires :name, :description, :database_id 
          data = service.create_snapshot(name, description, database_id)
        end
      end
    end
  end
end
