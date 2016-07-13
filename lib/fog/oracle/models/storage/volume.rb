require 'fog/core/model'

module Fog
  module Storage
  	class Oracle
	    class Volume < Fog::Model
	      identity  :name

	      attribute :status
	      attribute :account
	      attribute :writecache
	      attribute :managed
	      attribute :description
	      attribute :tags
        attribute :bootable
        attribute :hypervisor
        attribute :quota
        attribute :uri
        attribute :snapshot
        attribute :status_detail
        attribute :imagelist_entry
        attribute :storage_pool
        attribute :machineimage_name
        attribute :status_timestamp
        attribute :shared
        attribute :imagelist
        attribute :size
        attribute :name

 				def save
          #identity ? update : create
          create
        end

				def create
        	requires :name
          
          #data = service.create_security_application(name, protocol,
          #                                  :dport => dport,
          #                                  :icmptype => icmptype,
          #                                  :icmpcode => icmpcode,
          #                                  :description => description)
        end

        def destroy
          requires :name
          service.delete_volume(name)
        end
	    end
	  end
  end
end
