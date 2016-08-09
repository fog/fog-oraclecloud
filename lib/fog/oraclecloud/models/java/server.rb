require 'fog/compute/models/server'

module Fog
  module Oracle
    class Java
      class Server < Fog::Model
      	identity :name

      	attribute :clusterName
      	attribute :name
      	attribute :shape
      	attribute :nodeType
      	attribute :isAdmin
      	attribute :hostname
      	attribute :status
      	attribute :reservedIp
      	attribute :storageAllocated
      	attribute :creationDate

      	def ip_addr
          reservedIp.blank? ? hostname : reservedIp
        end
      end
    end
  end
end
