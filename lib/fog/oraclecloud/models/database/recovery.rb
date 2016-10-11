require 'fog/core/model'

module Fog
  module OracleCloud
    class Database
      class Recovery < Fog::Model

        attribute :db_tag, :aliases=>'dbTag'
        attribute :recovery_start_date,  :aliases=>'recoveryStartDate'
        attribute :recovery_complete_date,  :aliases=>'recoveryCompleteDate'
        attribute :status
        attribute :latest
        attribute :timestamp
        attribute :database_id
       
        def completed?
          status == "COMPLETED"
        end

        private

        def reload
          requires :database_id

          data = begin
            if !db_tag.nil? then
              collection.get(database_id, 'tag', db_tag)
            else
              collection.get(database_id)
            end
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
