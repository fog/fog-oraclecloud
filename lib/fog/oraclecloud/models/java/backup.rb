require 'fog/core/model'

module Fog
  module OracleCloud
    class Java
      class Backup < Fog::Model
        identity  :backup_id, :aliases=>'backupId'

        attribute :job_id, :aliases=>'jobId'        
        attribute :backup_startDate, :aliases=>'backupStartDate'
        attribute :backup_complete_date,  :aliases=>'backupCompleteDate'
        attribute :deleted_on_date, :aliases=>'deletedOnDate' 
        attribute :expiration_date, :aliases=>'expirationDate' 
        attribute :force_scale_in_required_for_restore, :aliases=>'forceScaleInRequiredForRestore'            
        attribute :full
        attribute :local
        attribute :local_copy, :aliases=>'localCopy'
        attribute :database_included, :aliases=>'databaseIncluded'
        attribute :size
        attribute :size_in_bytes, :aliases=>'sizeInBytes'        
        attribute :status
        attribute :service_components, :aliases=>'serviceComponents'
        attribute :job_history, :aliases=>'jobHistory'
        attribute :db_tag, :aliases=>'dbTag'
        attribute :service_name
        
        def completed?
          status == "Completed"
        end

        private

        # Had to override reload as we need to pass the service_name
        def reload
          requires :identity, :service_name

          data = begin
            collection.get(service_name, identity)
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
