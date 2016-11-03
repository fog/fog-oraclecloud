require 'fog/core/model'

module Fog
  module OracleCloud
    class Java
      class Instance < Fog::Model
        identity  :service_name, :aliases=>['name', 'serviceName']


        attribute :created_by

        attribute :auto_update
        attribute :cluster_name,      :aliases=>'clusterName'
        attribute :compliance_status
        attribute :compliance_status_desc
        attribute :compute_site_name
        attribute :content_url
        attribute :creation_job_id
        attribute :creation_time
        attribute :db_associations
        attribute :db_info
        attribute :db_service_name
        attribute :deletion_job_id
        attribute :description
        attribute :domain_mode,               :aliases=>'domainMode'
        attribute :edition
        attribute :error_status_desc
        attribute :fmw_control_url
        attribute :last_modified_time
        attribute :level
        attribute :lifecycle_control_job_id
        attribute :num_ip_reservations
        attribute :num_nodes,                  :aliases=>'managedServerCount'
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
        attribute :subscription_type,           :aliases=>['subscriptionType']
        attribute :uri
        attribute :version
        attribute :wls_admin_url
        attribute :wls_deployment_channel_port
        attribute :wls_version,               :aliases=>'wlsVersion'
        attribute :domain_name,               :aliases=>'domainName'
        attribute :pdb_name,                  :aliases=>['pdbName', 'pdb_service_name']


        # The following are only used to create an instance and are not returned in the list action
        attribute :cloud_storage_container,   :aliases=>'cloudStorageContainer'
        attribute :cloud_storage_user,        :aliases=>'cloudStorageUser'
        attribute :cloud_storage_pwd,         :aliases=>'cloudStoragePassword'
        attribute :admin_username,            :aliases=>'adminUserName'
        attribute :admin_password,            :aliases=>'adminPassword'
        attribute :ssh_key,                   :aliases=>'vmPublicKey'
        attribute :cloud_storage_container_if_missing,  :aliases=>'cloudStorageContainerIfMissing'
        attribute :enable_admin_console,      :aliases=>'enableAdminConsole'
        attribute :provision_otd,             :aliases=>'provisionOTD'
        attribute :sample_app_deployment_requested, :aliases=>'sampleAppDeploymentRequested'
        attribute :admin_port,                :aliases=>'adminPort'
        attribute :app_dbs,                   :aliases=>'appDBs'
        attribute :backup_volume_size,        :aliases=>'backupVolumeSize'
        attribute :content_port,              :aliases=>'contentPort'
        attribute :dba_name,                  :aliases=>'dbaName'
        attribute :dba_password,              :aliases=>'dbaPassword'
        attribute :domain_partition_count,    :aliases=>'domainPartitionCount'
        attribute :domain_volume_size,        :aliases=>'domainVolumeSize'
        attribute :ip_reservations,           :aliases=>'ipReservations'
        attribute :ms_initial_heap_mb,        :aliases=>'msInitialHeapMB'
        attribute :ms_jvm_args,               :aliases=>'msJvmArgs'
        attribute :ms_max_heap_mb,            :aliases=>'msMaxHeapMB'
        attribute :ms_max_perm_mb,            :aliases=>'msMaxPermMB'
        attribute :ms_perm_mb,                :aliases=>'msPermMb'
        attribute :node_manager_password,     :aliases=>'nodeManagerPassword'
        attribute :node_manager_port,         :aliases=>'nodeManagerPort'
        attribute :node_manager_user_name,    :aliases=>'nodeManagerUserName'
        attribute :overwrite_ms_jvm_args,     :aliases=>'overwriteMsJvmArgs'
        attribute :secured_admin_port,        :aliases=>'securedAdminPort'
        attribute :secured_content_port,      :aliases=>'securedContentPort'

        # The following are used to delete an instance and are not returned in the list action
        attribute :force_delete

        def level=(value)
          if %w(PAAS BASIC).include? value then
            attributes[:level]=value
          else
            raise ArgumentError, "Invalid level. Valid values - PAAS or BASIC"
          end
        end

        def subscription_type=(value)
          if %w(HOURLY MONTHLY).include? value then
            attributes[:subscription_type]=value
          else
            raise ArgumentError, "Invalid subscription type. Valid values - HOURLY or MONTHLY"
          end
        end

        def domain_mode=(value)
          if value.to_s == '' then value = 'DEVELOPMENT' end
          if %w(DEVELOPMENT PRODUCTION).include? value then
            attributes[:domain_mode]=value
          else
            raise ArgumentError, "Invalid domain mode '#{value}'. Valid values - DEVELOPMENT or PRODUCTION"
          end
        end

        def edition=(value)
          if value.to_s == '' then value = 'EE' end
          if %w(SE EE SUITE).include? value then
            attributes[:edition]=value
          else
            raise ArgumentError, "Invalid edition. Valid values - SE, EE or SUITE"
          end
        end


        def shape=(value)
          if %w(oc3 oc4 oc5 oc6 oc1m oc2m oc3m oc4m).include? value then
            attributes[:shape]=value
          else
            raise ArgumentError, "Invalid Shape. Valid values - oc3, oc4, oc5, oc6, oc1m, oc2m, oc3m or oc4m"
          end
        end

        def num_nodes=(value)
          if value.nil? then value = 1 end
          if [1, 2, 4, 8].include? value.to_i then
            attributes[:num_nodes] = value.to_i
          else
            raise ArgumentError, "Invalid server count (#{value}). Valid values - 1, 2, 4 or 8"
          end
        end

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

        def stopping?
          status == 'Maintenance' || status == 'Terminating'
        end

        def stopped?
          status == 'Stopped'
        end

        def servers
          service.servers.all(service_name)
        end
				
		    def destroy
          requires :service_name, :dba_name, :dba_password
          service.delete_instance(service_name, dba_name, dba_password, :force_delete => force_delete).body
        end

        def scale_out_a_cluster(cluster_name, createClusterIfMissing)
          requires :service_name
          service.scale_out_a_cluster(service_name, cluster_name, createClusterIfMissing).body        
        end

        def scale_in_a_cluster(server_name)
          requires :service_name
          service.scale_in_a_cluster(service_name, server_name).body       
        end

        #def scale_a_node(shape)
        #  service.scale_a_node(service_name, :shape=>shape).body       
        #end

        private

        def create
        	requires :service_name, :dba_name, :dba_password, :db_service_name, :shape, :version, :ssh_key, :admin_password, :admin_username
          
          #data = service.create_instance(service_name, cloud_storage_container, cloud_storage_user, cloud_storage_password, dba_name, dba_password, db_servicename, shape, version, vm_public_key,
          #                                  :level => level,
          #                                  :subscriptionType => subscription_type,
          #                                  :description => description)

          if cloud_storage_container.nil? then
            cloud_storage_if_missing = true
            stor_name = "#{service_name}_Backup"
          else
            stor_name = cloud_storage_container
          end
          stor_user = cloud_storage_user || service.username
          stor_pwd = cloud_storage_pwd || service.password

          params = {            
            :serviceName => service_name,
            :cloudStorageContainer => stor_name,
            :cloudStoragePassword => stor_user,
            :cloudStorageUser => stor_pwd,
            :cloudStorageContainerIfMissing => cloud_storage_if_missing,
            :description => description,
            :enableAdminConsole => enable_admin_console.nil? ? true : enable_admin_console,
            :provisionOTD => provision_otd.nil? ? true : provision_otd,
            :sampleAppDeploymentRequested => sample_app_deployment_requested.nil? ? true : sample_app_deployment_requested,
            :subscriptionType => subscription_type || 'HOURLY',
            :level => level || 'PAAS',
          }
          options = {
            :adminPassword => admin_password,
            :adminPort => admin_port,
            :adminUserName => admin_username,
            :backupVolumeSize => backup_volume_size,
            :clusterName => cluster_name,
            :contentPort => content_port,
            :dbaName => dba_name,
            :dbaPassword => dba_password,
            :dbServiceName => db_service_name,
            :deploymentChannelPort => wls_deployment_channel_port,
            :domainMode => domain_mode,
            :domainName => domain_name,
            :domainPartitionCount => domain_partition_count,
            :domainVolumeSize => domain_volume_size,
            :edition => edition || 'EE',
            :ipReservations => ip_reservations,
            :managedServerCount => num_nodes || 1,
            :msInitialHeapMB => ms_initial_heap_mb,
            :msJvmArgs => ms_jvm_args,
            :msMaxHeapMB => ms_max_heap_mb,
            :msMaxPermMB => ms_max_perm_mb,
            :msPermMb => ms_perm_mb,
            :nodeManagerPassword => node_manager_password,
            :nodeManagerPort => node_manager_port,
            :nodeManagerUserName => node_manager_user_name,
            :overwriteMsJvmArgs => overwrite_ms_jvm_args,
            :pdbName => pdb_name,
            :securedAdminPort => secured_admin_port,
            :securedContentPort => secured_content_port,
            :shape => shape,
            :VMsPublicKey => ssh_key,
            :version => version
          }

          if app_dbs and app_dbs.is_a? Array and app_dbs.size >= 1
            options[:appDBs] = []
            app_dbs.each { |db| options[:appDBs].push({
              :dbaName => db.username,
              :dbaPassword => db.password,
              :dbServiceName => db.service_name,
              }) } 
          end
          data = service.create_instance(params, options)

        end

      end
    end
  end
end
