require 'fog/core/model'

module Fog
  module OracleCloud
    class Database
      class Instance < Fog::Model
        identity  :service_name,        :aliases=>'serviceName'

        attribute :version
        attribute :status
        attribute :description,     :aliases=>'serviceDescription'
        attribute :domain_name,     :aliases=>'domainName'
        attribute :creation_date
        attribute :last_modified_time
        attribute :created_by,      :aliases=>'creator'
        attribute :sm_plugin_version
        attribute :service_uri
        attribute :num_nodes
        attribute :level,       :aliases=>'serviceLevel'
        attribute :edition
        attribute :shape
        attribute :subscription_type,   :aliases=>['subscriptionType', 'subscription']
        attribute :creation_job_id
        attribute :num_ip_reservations
        attribute :backup_destination
        attribute :cloud_storage_container,   :aliases=>'cloudStorageContainer'
        attribute :failover_database
        attribute :sid
        attribute :pdb_name,        :aliases=>'pdbName'
        attribute :listenerPort
        attribute :timezone
        attribute :em_url
        attribute :connect_descriptor
        attribute :connect_descriptor_with_public_ip
        attribute :apex_url
        attribute :glassfish_url
        attribute :dbaasmonitor_url
        attribute :compute_site_name
        attribute :charset  
        attribute :ncharset 
        attribute :is_rac,      :aliases=>['isRac', 'rac_database']   
        attribute :total_shared_storage,    :aliases=>'totalSharedStorage'      
        attribute :service_type, :aliases=>'serviceType'

        # The following are only used to create an instance and are not returned in the list or get actions
        attribute :ssh_key,             :aliases=>'vmPublicKeyText'
        attribute :admin_password
        attribute :cloud_storage_pwd,    :aliases=>'cloudStoragePwd'
        attribute :cloud_storage_user,    :aliases=>'cloudStorageUser'
        attribute :cloud_storage_container_if_missing,  :aliases=>'cloudStorageContainerIfMissing'
        attribute :disaster_recovery,   :aliases=>'disasterRecovery'
        attribute :golden_gate,       :aliases=>'goldenGate'
        attribute :usable_storage,  :aliases=>'usableStorage'

        def edition=(value)
          if %w(SE EE EE_HP EE_EP).include? value then
            attributes[:edition]=value
          else
            raise ArgumentError, "Invalid Edition. Valid values - SE, EE, EE_HP, EE_EP"
          end
        end

        def level=(value)
          if %w(PAAS BASIC).include? value then
            attributes[:level]=value
          else
            raise ArgumentError, "Invalid level. Valid values - PAAS or BASIC"
          end
        end

        def shape=(value)
          if %w(oc3 oc4 oc5 oc6 oc1m oc2m oc3m oc4m).include? value then
            attributes[:shape]=value
          else
            raise ArgumentError, "Invalid Shape. Valid values - oc3, oc4, oc5, oc6, oc1m, oc2m, oc3m or oc4m"
          end
        end

        def subscription_type=(value)
          if %w(HOURLY MONTHLY).include? value then
            attributes[:subscription_type]=value
          else
            raise ArgumentError, "Invalid subscription type. Valid values - HOURLY or MONTHLY"
          end
        end

        def backup_destination=(value)
          if %w(BOTH OSS NONE).include? value then
            attributes[:backup_destination]=value
          else
            raise ArgumentError, "Invalid backup destination. Valid values - BOTH, OSS or NONE"
          end
        end

        def disaster_recovery=(value)
          if %w(yes no).include? value then
            attributes[:disaster_recovery]=value
          else
            raise ArgumentError, "Invalid disaster recovery value"
          end
        end

        def failover_database=(value)
          if value == true
            value = 'yes'
          elsif value == false || value.nil?
            value = 'no'
          end
          if %w(yes no).include? value then
            attributes[:failover_database]=value
          else
            raise ArgumentError, "Invalid failover database value"
          end
        end

        def is_rac=(value)
          if value == true
            value = 'yes'
          elsif value == false || value.nil?
            value = 'no'
          end
          if %w(yes no).include? value then
            attributes[:is_rac]=value
          else
            raise ArgumentError, "Invalid is_rac value"
          end
        end

        def ncharset=(value)
          if value.nil? then
            attributes[:ncharset] = 'AL16UTF16'
          elsif %w(AL16UTF16 UTF8).include? value then
            attributes[:ncharset]=value
          else
            raise ArgumentError, "Invalid ncharset"
          end
        end

        def usable_storage=(value)
          if value.to_f >= 15 && value.to_f <= 1000 then
            attributes[:usable_storage]=value
          else
            raise ArgumentError, "Usable storage value is invalid: #{value.to_f}"
          end
        end


        def clean_name 
          name.sub %r{\/.*\/}, ''
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

        def ip_address
            # TODO: Replace with regex
            content_url.sub('http://', '')
        end

        def destroy
          requires :service_name
          service.delete_instance(service_name).body
        end

        def scale(shape)
          requires :service_name
          service.scale_instance(service_name, :shape=>shape).body
        end

        def add_storage(size)
          requires :service_name
          service.scale_instance(service_name, :additional_storage=>size).body
        end

        def expand_storage(size, type=nil)
          requires :service_name
          if type.nil? then type = 'data' end
          if type == 'backup' then type ='fra' end
          service.scale_instance(service_name, :additional_storage=>size, :usage=>type).body
        end

        def snapshots
          requires :service_name
          service.snapshots.all(service_name)
        end

        def get_snapshot(snapshot_name)
          requires :service_name
          service.snapshots.get(service_name, snapshot_name)
        end

        def servers
          requires :service_name
          service.servers.all(service_name)
        end

        def backup
          requires :service_name
          service.backup_instance(service_name)
        end

        def backups
          requires :service_name
          service.backups.all(service_name)
        end

        def recover(type, value)
          # Valid types are 'scn', 'tag' or 'timestamp'
          requires :service_name
          service.recover_instance(service_name, type, value)
        end

        def recover_latest
          requires :service_name
          service.recover_instance(service_name)
        end

        def recoveries
          requires :service_name
          service.recoveries.all(service_name)
        end

        def patches
          requires :service_name
          service.patches.all(service_name)
        end

        private

        def create
          requires :service_name, :edition, :ssh_key, :shape, :version, :admin_password, :backup_destination

          if backup_destination != 'NONE' then
            if cloud_storage_container.nil? then
              cloud_storage_if_missing = true
              stor_name = "#{service_name}_Backup"
            else
              stor_name = cloud_storage_container
            end
            stor_user = cloud_storage_user || service.username
            stor_pwd = cloud_storage_pwd || service.password
          end

          if !disaster_recovery.nil? && (failover_database.nil? || failover_database == 'no') then raise ArgumentError, 'Can\'t set disaster recovery option without failover_database set to \'yes\'' end
          if failover_database == 'yes' && golden_gate == 'yes' then raise ArgumentError, 'Can\'t set failover_database and golden_gate both to \'yes\'' end
          if is_rac == 'yes' && (failover_database == 'yes' || golden_gate == 'yes') then raise ArgumentError, 'Can\'t set is_rac and failover_database or golden_gate both to \'yes\'' end

          params = {
            :service_name => service_name,
            :edition => edition,
            :ssh_key => ssh_key,
            :shape => shape,
            :version => version,
            :level => level || 'PAAS',
            :subscription_type => subscription_type || 'HOURLY',
            :description => description
          }
          options = {
            :admin_password => admin_password,
            :charset => charset,
            :backup_destination => backup_destination,
            :cloud_storage_container => stor_name,
            :cloud_storage_pwd => stor_user,
            :cloud_storage_user => stor_pwd,
            :cloud_storage_if_missing => cloud_storage_if_missing,
            :disaster_recovery => disaster_recovery,
            :failover_database => failover_database,
            :golden_gate => golden_gate,
            :is_rac => is_rac,
            :ncharset => ncharset,
            :pdb_name => pdb_name,
            :sid => sid || 'ORCL',
            :timezone => timezone,
            :usable_storage => usable_storage || 25
          }
          data = service.create_instance(params, options)
        end
      end
    end
  end
end
