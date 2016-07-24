require 'fog/core/model'

module Fog
  module Oracle
    class SOA
      class Instance < Fog::Model
        identity  :service_name

        attribute :service_name       
        attribute :service_type
        attribute :resource_count
        attribute :status
        attribute :description
        attribute :identity_domain
        attribute :creation_job_id
        attribute :creation_time
        attribute :last_modified_time
        attribute :created_by
        attribute :service_uri
        attribute :provisioning_progress

        # The following are only used to create an instance and are not returned in the list action
        attribute :cloudStorageContainer
        attribute :cloudStorageUser
        attribute :cloudStoragePassword
        attribute :level
        attribute :subscriptionType
        attribute :topology
        attribute :parameters

        # The following are used to delete an instance and are not returned in the list action
        attribute :dba_name
        attribute :dba_password
        attribute :force_delete
        attribute :skip_backup

        def save
          #identity ? update : create
          create
        end

        def ready?
          status == "Running"
        end

        def destroy
          requires :service_name, :dba_name, :dba_password
          service.delete_instance(service_name, dba_name, dba_password, 
                                            :force_delete => force_delete,
                                            :skip_backup => skip_backup).body
        end

        private

        def create
          requires :service_name, :topology, :cloudStorageContainer, :cloudStorageUser, :cloudStoragePassword, :parameters 
          data = service.create_instance(service_name, topology, cloudStorageContainer, cloudStorageUser, cloudStoragePassword, parameters,
                                            :level => level,
                                            :subscriptionType => subscriptionType,
                                            :description => description)
        end
      end
    end
  end
end
