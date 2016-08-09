require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
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

 				def save
          #identity ? update : create
          create
        end

				def create
        	requires :name, :size

          data = service.create_volume(name, size)
        end

        def destroy
          requires :name
          service.delete_volume(name)
        end
	    end
	  end
  end
end
