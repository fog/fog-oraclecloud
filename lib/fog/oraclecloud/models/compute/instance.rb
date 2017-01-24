require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class Instance < Fog::Model
	      identity  :name

	      attribute :account
	      attribute :boot_order
	      attribute :disk_attach
	      attribute :domain
	     	attribute :entry
	      attribute :error_reason
	      attribute :fingerprint
	      attribute :hostname
	      attribute :hypervisor
	      attribute :image_format
	      attribute :imagelist
	      attribute :ip
	      attribute :label
	      attribute :networking
	      attribute :placement_requirements
	      attribute :platform
	      attribute :priority
	      attribute :quota
	      attribute :quota_reservation
	      attribute :resolvers
	      attribute :reverse_dns
	      attribute :shape
	      attribute :site
	      attribute :sshkeys
	      attribute :start_time
	      attribute :state
	      attribute :storage_attachments
	      attribute :tags
	      attribute :uri
	      attribute :vcable_id
	      attribute :virtio
	      attribute :vnc 

	      def initialize(attributes={})
	      	self.shape ||= 'oc3'
	      	super
	      end

	      def ready?
	      	state == 'running'
	      end

	      def clean_name 
	      	name.sub %r{\/.*\/}, ''
	      end

 				def save
          #identity ? update : create
          create
        end

        def create
        	requires :name, :shape, :imagelist, :sshkeys
          
          data = service.create_instance(name, shape, imagelist, label, sshkeys)
          merge_attributes(data.body['instances'][0])
        end

        def destroy
        	requires :name
        	service.delete_instance(name)
        end
	    end
	  end
  end
end
