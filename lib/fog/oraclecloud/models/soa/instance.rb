require 'fog/core/model'

module Fog
  module OracleCloud
    class SOA
      class Instance < Fog::Model
        identity  :service_name,              :aliases=>'serviceName'

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
        attribute :db_service_name,           :aliases=>'dbServiceName'
        attribute :num_nodes,                 :aliases=>'managedServerCount'
        attribute :shape
        attribute :version
        attribute :ssh_key,                   :aliases=>'vmPublicKey'

        # The following are only used to create an instance and are not returned in the list action
        attribute :cloud_storage_container,   :aliases=>'cloudStorageContainer'
        attribute :cloud_storage_user,        :aliases=>'cloudStorageUser'
        attribute :cloud_storage_pwd,         :aliases=>'cloudStoragePassword'
        attribute :level
        attribute :subscription_type,         :aliases=>'subscriptionType'
        attribute :topology
        attribute :admin_username,            :aliases=>'adminUserName'
        attribute :admin_password,            :aliases=>'adminPassword'
        attribute :dba_name,                  :aliases=>'dbaName'
        attribute :dba_password,              :aliases=>'dbaPassword'
        attribute :provision_otd,             :aliases=>'provisionOtd'

        # The following are used to delete an instance and are not returned in the list action
        attribute :dba_password
        attribute :force_delete
        attribute :skip_backup

        def topology=(value)
          if %w(osb soa soaosb b2b mft apim insight).include? value then
            attributes[:topology]=value
          else
            raise ArgumentError, "Invalid topology. Valid values - osb, soa, soaosb, b2b, mft, apim, insight"
          end
        end

        def num_nodes=(value)
          if value.nil? then value = 1 end
          if [1, 2, 4].include? value.to_i then
            attributes[:num_nodes] = value.to_i
          else
            raise ArgumentError, "Invalid server count (#{value}). Valid values - 1, 2 or 4"
          end
        end

        def shape=(value)
          if %w( oc1m oc2m oc3m oc4m oc5m).include? value then
            attributes[:shape]=value
          else
            raise ArgumentError, "Invalid Shape. Valid values - oc1m, oc2m, oc3m, oc4m or oc5m"
          end
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

        def destroy
          requires :service_name, :dba_name, :dba_password
          service.delete_instance(service_name, dba_name, dba_password, 
                                            :force_delete => force_delete,
                                            :skip_backup => skip_backup).body
        end

        private

        def create
          requires :service_name, :dba_name, :dba_password, :db_service_name, :shape, :version, :ssh_key, :admin_password, :admin_username, :cloud_storage_container, :topology

          stor_user = cloud_storage_user || service.username
          stor_pwd = cloud_storage_pwd || service.password

          params = {            
            :serviceName => service_name,
            :cloudStorageContainer => cloud_storage_container,
            :cloudStoragePassword => cloud_storage_pwd,
            :cloudStorageUser => cloud_storage_user,
            :description => description,
            :provisionOTD => provision_otd.nil? ? true : provision_otd,
            :subscriptionType => 'MONTHLY',
            :level => 'PAAS',
            :topology => topology
          }
          options = {
            :adminPassword => admin_password,
            :adminUserName => admin_username,
            :dbaName => dba_name,
            :dbaPassword => dba_password,
            :dbServiceName => db_service_name,
            :managedServerCount => num_nodes || 1,
            :shape => shape,
            :VMsPublicKey => ssh_key,
            :version => version
          }

          data = service.create_instance(params, options)
        end
      end
    end
  end
end
