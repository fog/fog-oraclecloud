require 'fog/core/model'

module Fog
  module OracleCloud
    class Database
      class Instance < Fog::Model
        identity  :service_name

        attribute :version
        attribute :status
        attribute :description
        attribute :identity_domain
        attribute :creation_time
        attribute :last_modified_time
        attribute :created_by
        attribute :sm_plugin_version
        attribute :service_uri
        attribute :num_nodes
        attribute :level
        attribute :edition
        attribute :shape
        attribute :subscriptionType
        attribute :creation_job_id
        attribute :num_ip_reservations
        attribute :backup_destination
        attribute :cloud_storage_container
        attribute :failover_database
        attribute :rac_database
        attribute :sid
        attribute :pdbName
        attribute :listenerPort
        attribute :timezone
        attribute :em_url
        attribute :connect_descriptor
        attribute :connect_descriptor_with_public_ip
        attribute :apex_url
        attribute :glassfish_url
        attribute :dbaasmonitor_url
        attribute :compute_site_name

        # The following are only used to create an instance and are not returned in the list action
        attribute :vmPublicKey
        attribute :parameters

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

        private

        def create
          requires :service_name, :edition, :vmPublicKey, :shape, :version 
          data = service.create_instance(service_name, edition, vmPublicKey, shape, version,
                                            :level => level,
                                            :subscriptionType => subscriptionType,
                                            :description => description,
                                            :edition => edition)

        end
      end
    end
  end
end
