require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class StorageAttachment < Fog::Model
	      identity  :uri

	      attribute :account
	      attribute :hypervisor
	      attribute :index
	      attribute :instance_name
	      attribute :read_only,      :aliases=>'readonly'
	      attribute :state
        attribute :storage_volume_name
        attribute :name

        def save
          #identity ? update : create
          create
        end

        def create 
          requires :index, :instance_name, :storage_volume_name
          data = service.create_storage_attachment({
          	:index => index,
            :instance_name => instance_name,
            :storage_volume_name => storage_volume_name,
          })
          merge_attributes(data.body)
        end

        def destroy
        	requires :name
        	service.delete_storage_container(name)
        end

	    end
	  end
  end
end
