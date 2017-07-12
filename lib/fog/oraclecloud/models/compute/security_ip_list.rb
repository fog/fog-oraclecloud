require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class SecurityIpList < Fog::Model
	      identity  :name

	      attribute :description
	      attribute :uri
	      attribute :secipentries

 	      def save
          #identity ? update : create
          create
        end

        def create
        	requires :name, :secipentries
          
          data = service.create_security_ip_list(name, description, secipentries)
          merge_attributes(data.body)
        end
	    end
	  end
  end
end
