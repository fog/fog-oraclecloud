require 'fog/core/model'

module Fog
  module OracleCloud
    class Java
      class Instance < Fog::Model
        identity  :service_name, :aliases=>'name'


        attribute :created_by

        attribute :auto_update
        attribute :cluster_name
        attribute :compliance_status
        attribute :compliance_status_desc
        attribute :compute_site_name
        attribute :content_url
        attribute :creation_job_id
        attribute :creation_time
        attribute :db_associations
        attribute :db_info
        attribute :db_servicename
        attribute :deletion_job_id
        attribute :description
        attribute :domain_mode
        attribute :edition
        attribute :error_status_desc
        attribute :fmw_control_url
        attribute :last_modified_time
        attribute :level
        attribute :lifecycle_control_job_id
        attribute :num_ip_reservations
        attribute :num_nodes
        attribute :options
        attribute :otd_admin_url
        attribute :otd_provisioned
        attribute :otd_shape
        attribute :otd_strorage_size
        attribute :psm_plugin_version
        attribute :sample_app_url
        attribute :secure_content_url
        attribute :service_components
        attribute :service_type
        attribute :service_uri
        attribute :shape
        attribute :status
        attribute :subscription_type
        attribute :uri
        attribute :version
        attribute :wls_admin_url
        attribute :wls_deployment_channel_port
        attribute :wls_version,               :aliases=>'wlsVersion'


        # The following are only used to create an instance and are not returned in the list action
        attribute :cloud_storage_container,   :aliases=>'cloudStorageContainer'
        attribute :cloud_storage_user,        :aliases=>'cloudStorageUser'
        attribute :cloud_storage_password,    :aliases=>'cloudStoragePassword'
        attribute :admin_user_name,           :aliases=>'adminUserName'

        # The following are used to delete an instance and are not returned in the list action
        attribute :dba_name
        attribute :dba_password
        attribute :force_delete

        def initialize(attributes={})
          level ||= 'PAAS'
          subscription_type ||= 'HOURLY'
          edition ||= 'EE'

          super
        end

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
