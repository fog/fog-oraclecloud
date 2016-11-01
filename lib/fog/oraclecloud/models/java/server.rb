require 'fog/compute/models/server'

module Fog
  module OracleCloud
    class Java
      class Server < Fog::Model
      	identity :name

      	attribute :cluster_name,     :aliases=>'clusterName'
        attribute :job_id,           :aliases=>'jobId'
      	attribute :name
      	attribute :shape
      	attribute :node_type,        :aliases=>'nodeType'
      	attribute :is_admin,         :aliases=>'isAdmin'
      	attribute :hostname
      	attribute :status
      	attribute :reserved_ip,      :aliases=>'reservedIp'
        attribute :reserved_ipaddress,      :aliases=>'reservedIpAddress'
        attribute :reserved_ipname,      :aliases=>'reservedIpName'
      	attribute :storage_allocated, :aliases=>'storageAllocated'
      	attribute :creation_date,     :aliases=>'creationDate'

      	def ip_addr
          reserved_ip.blank? ? hostname : reserved_ip
        end

        def ready?
          status == "Ready"
        end

      end
    end
  end
end
