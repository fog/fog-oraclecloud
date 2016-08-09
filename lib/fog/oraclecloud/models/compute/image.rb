require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class Image < Fog::Model
	      identity  :name

	      attribute :account
	      attribute :sizes
	      attribute :hypervisor
	      attribute :uri
	     	attribute :quota
	      attribute :platform
	      attribute :no_upload
	      attribute :state
	      attribute :signed_by
	      attribute :file
	      attribute :signature
	      attribute :checksums
	      attribute :error_reason
	      attribute :image_format
	      attribute :audited

 				def save
          #identity ? update : create
          create
        end

        def create
        	requires :account, :name, :no_upload, :file, :sizes
          
          data = service.create_image(account, name, no_upload, file, sizes)
        end

        def delete
        	requires :image_list_name
        	service.delete_image(image_list_name, version)
        end
	    end
	  end
  end
end
