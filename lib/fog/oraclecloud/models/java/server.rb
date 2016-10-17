require 'fog/compute/models/server'

module Fog
  module OracleCloud
    class Java
      class Server < Fog::Model
      	identity :name

      	attribute :cluster_name,     :aliases=>'clusterName'
      	attribute :name
      	attribute :shape
      	attribute :node_type,        :aliases=>'nodeType'
      	attribute :is_admin,         :aliases=>'is_admin'
      	attribute :hostname
      	attribute :status
      	attribute :reserved_ip,      :aliases=>'reserved_ip'
      	attribute :storage_allocated, :aliases=>'storageAllocated'
      	attribute :creation_date,     :aliases=>'creationDate'

      	def ip_addr
          reserved_ip.blank? ? hostname : reserved_ip
        end
      end
    end
  end
end
