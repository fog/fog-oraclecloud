require 'fog/core/model'

module Fog
  module OracleCloud
    class Database
      class AccessRule < Fog::Model
        identity  :ruleName

        attribute :destination
        attribute :description
        attribute :ports
        attribute :source
        attribute :status

        attribute :database_id
       
        def save
          create
        end

        def destroy
          requires :name, :database_id
          service.delete_snapshot(database_id, name).body
        end

        # Had to override reload as we need to pass the database_id
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
          requires :ruleName, :database_id, :source 
          service.create_access_rule(database_id, ruleName, description, ports, source, destination || 'DB', status || 'enabled')
        end
      end
    end
  end
end
