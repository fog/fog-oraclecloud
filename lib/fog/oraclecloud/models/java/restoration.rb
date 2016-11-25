require 'fog/core/model'

module Fog
  module OracleCloud
    class Java
      class Restoration < Fog::Model

        attribute :backup_id, :aliases=>'backupId'
        attribute :backup_date, :aliases=>'backupDate'
        attribute :job_id, :aliases=>'jobId'
        attribute :recovery_start_date,  :aliases=>'recoveryStartDate'
        attribute :recovery_complete_date,  :aliases=>'recoveryCompleteDate'
        attribute :status
        attribute :status_details, :aliases=>'statusDetails'
        attribute :static_data_included, :aliases=>'staticDataIncluded'
        attribute :config_data_included, :aliases=>'configDataIncluded'
        attribute :otd_included, :aliases=>'otdIncluded'
        attribute :database_included, :aliases=>'databaseIncluded'        
        attribute :notes
        attribute :timestamp
        attribute :service_name
       
        def completed?
          status == "COMPLETED"
        end

        private

        def reload
          requires :service_name

          data = begin
            if !db_tag.nil? then
              collection.get(service_name, 'tag', db_tag)
            else
              collection.get(service_name)
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
