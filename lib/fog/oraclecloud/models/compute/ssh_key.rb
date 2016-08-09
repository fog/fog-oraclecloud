require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class SshKey < Fog::Model
	      identity  :uri

	      attribute :enabled
	      attribute :key
	      attribute :name
	  
 				def save
         	identity ? update : create
        end

        def create
        	requires :enabled, :name, :key
          
          data = service.create_ssh_key(name, enabled, key)
          merge_attributes(data.body)
        end

        def update
        	requires :enabled, :name, :key, :uri
        	data = service.update_ssh_key(name, enabled, key)
        	merge_attributes(data.body)
        end

        def destroy
        	requires :name
        	service.delete_ssh_key(name)
        end
	    end
	  end
  end
end
