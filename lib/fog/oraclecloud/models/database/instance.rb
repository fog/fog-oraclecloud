require 'fog/core/model'

module Fog
  module Oracle
    class Database
      class Instance < Fog::Model
        identity  :service_name

        attribute :service_name,                 :aliases => 'display_name'
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
        attribute :level
        attribute :subscriptionType
        attribute :vmPublicKey
        attribute :parameters


         def save
          #identity ? update : create
          create
        end

        def ready?
          status == "Running"
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
          requires :service_name, :edition, :vmPublicKey, :parameters 
          data = service.create_instance(service_name, edition, vmPublicKey, parameters,
                                            :level => level,
                                            :subscriptionType => subscriptionType,
                                            :description => description,
                                            :version => version,
                                            :edition => edition,
                                            :shape => shape)

        end
      end
    end
  end
end
