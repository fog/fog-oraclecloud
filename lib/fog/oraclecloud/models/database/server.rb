require 'fog/core/model'

module Fog
  module OracleCloud
    class Database
      class Server < Fog::Model
        identity :hostname

        attribute :connect_descriptor
        attribute :connect_descriptor_with_public_ip
        attribute :created_by
        attribute :creation_job_id
        attribute :creation_time
        attribute :initial_primary,     :aliases=>'initialPrimary'
        attribute :listener_port,       :aliases=>'listenerPort'
        attribute :pdb_name,            :aliases=>'pdbName'
        attribute :reserved_ip,         :aliases=>'reservedIP'
        attribute :shape
        attribute :sid
        attribute :status
        attribute :storage_allocated,   :aliases=>'storageAllocated'

        private

      end
    end
  end
end
