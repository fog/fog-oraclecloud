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
        attribute :service_name

      	def ip_addr
          reserved_ip.blank? ? hostname : reserved_ip
        end

        def ready?
          status == "Ready"
        end

        def scale(shape)
          if !%w(oc3 oc4 oc5 oc6 oc1m oc2m oc3m oc4m).include? shape then
            raise ArgumentError, "Invalid Shape. Valid values - oc3, oc4, oc5, oc6, oc1m, oc2m, oc3m or oc4m"
          end
          service.scale_a_node(service_name, name, :shape=>shape)
        end

        def scale_in_a_cluster
          requires :service_name, :identity
          service.scale_in_a_cluster(service_name, identity)
        end

        def reload
          requires :identity, :service_name

          data = begin
            collection.get(service_name, identity)
          rescue Excon::Errors::SocketError
            nil
          end

          return unless data

          new_attributes = data.attributes
          merge_attributes(new_attributes)
          self
        end
      end
    end
  end
end
