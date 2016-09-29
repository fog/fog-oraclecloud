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
