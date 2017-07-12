require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class SecurityRule < Fog::Model
	      identity  :name

	      attribute :dst_list
	      attribute :src_list
	      attribute :uri
	      attribute :disabled
	      attribute :application
        attribute :proxyuri
        attribute :action

	      # Only used in create
	      attribute :description

 				def save
          #identity ? update : create
          create
        end

				def create
        	requires :name, :src_list, :dst_list, :application
          
          data = service.create_security_rule(name, src_list, dst_list, application, 'PERMIT',
                                            :description => description,
                                            :disabled => disabled)
          merge_attributes(data.body)
        end

        def destroy
          requires :name
          service.delete_security_rule(name)
        end
	    end
	  end
  end
end
