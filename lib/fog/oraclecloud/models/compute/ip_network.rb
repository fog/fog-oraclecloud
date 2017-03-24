require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class IpNetwork < Fog::Model
	      identity  :name

	      attribute :uri
	      attribute :description
	      attribute :tags
	      attribute :ip_address_prefix,        :aliases=>'ipAddressPrefix'
	      attribute :ip_network_exchange,      :aliases=>'ipNetworkExchange'
	      attribute :public_napt_enabled_flag, :aliases=>'publicNaptEnabledFlag'

 				def save
          requires :name, :ip_address_prefix
 					if !name.nil? && !name.start_with?("/Compute-") then
	          create
	         else
	         	update
	        end
        end

        def create 
          data = service.create_ip_network({
          	:name => name,
          	:ipAddressPrefix => ip_address_prefix, 
          	:ipNetworkExchange => ip_network_exchange,
          })
          merge_attributes(data.body)
        end

        def update
        	data = service.update_ip_network({
            :name => name,
            :ipAddressPrefix => ip_address_prefix, 
            :ipNetworkExchange => ip_network_exchange,
        	})
        	merge_attributes(data.body)
        end

        def destroy
        	requires :name
        	service.delete_ip_network(name)
        end

	    end
	  end
  end
end
