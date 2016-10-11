require 'fog/core/model'

module Fog
  module OracleCloud
    class Database
      class Backup < Fog::Model
        identity  :db_tag, :aliases=>'dbTag'

        attribute :backup_complete_date,  :aliases=>'backupCompleteDate'
        attribute :status
        attribute :database_id
       
        def completed?
          status == "COMPLETED"
        end

        private

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
      end
    end
  end
end
