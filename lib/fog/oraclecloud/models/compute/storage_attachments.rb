require 'fog/core/collection'

module Fog
  module Compute
  	class OracleCloud
	    class StorageAttachments < Fog::Collection

	    	model Fog::Compute::OracleCloud::StorageAttachment
				
				def all
					data = service.list_storage_attachments().body['result']
					load(data)
				end

 				def get(name)
          data = service.get_storage_attachment(name).body
          new(data)
        end
	    end
	  end
  end
end
