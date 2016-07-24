require 'fog/core/model'

module Fog
  module Oracle
    class Java
      class Instance < Fog::Model
        identity  :service_name

        attribute :version
        attribute :wlsVersion
        attribute :status
        attribute :error_status_desc
        attribute :compliance_status
        attribute :auto_update
        attribute :description
        attribute :identity_domain
        attribute :creation_time
        attribute :last_modified_time
        attribute :created_by
        attribute :service_uri
        attribute :shape

        attribute :content_url									

        # The following are only used to create an instance and are not returned in the list action
        attribute :cloudStorageContainer
        attribute :cloudStorageUser
        attribute :cloudStoragePassword
        attribute :level
        attribute :subscriptionType
        attribute :parameters

        # The following are used to delete an instance and are not returned in the list action
        attribute :dba_name
        attribute :dba_password
        attribute :force_delete

        def save
          #identity ? update : create
          create
        end

        def ready?
          status == "Running"
        end

        def servers
          service.servers.all(service_name)
        end
				
				def destroy
          requires :service_name, :dba_name, :dba_password
          service.delete_instance(service_name, dba_name, dba_password, :force_delete => force_delete).body
        end

        private

        def create
        	requires :service_name, :cloudStorageContainer, :cloudStorageUser, :cloudStoragePassword, :parameters 
          
          data = service.create_instance(service_name, cloudStorageContainer, cloudStorageUser, cloudStoragePassword, parameters,
                                            :level => level,
                                            :subscriptionType => subscriptionType,
                                            :description => description)

        end

      end
    end
  end
end
