require 'fog/core/model'

module Fog
  module Compute
  	class OracleCloud
	    class SecurityList < Fog::Model
	      identity  :name

	      attribute :account
	      attribute :description
	      attribute :uri
	      attribute :outbound_cidr_policy
	      attribute :proxyuri
	      attribute :policy

	      # Only used in create
	      attribute :description

 				def save
          #identity ? update : create
          create
        end

        def create
        	requires :name
          
          data = service.create_security_list(name, description, policy, outbound_cidr_policy)
          merge_attributes(data.body)

        end

				def destroy
        	requires :name
        	service.delete_security_list(name)
        end

        def add_rule (port, list, rule_name=nil) 
        	if !rule_name then rule_name = "#{name}_#{port}_#{list}" end
        	if port.is_a? Numeric then
        		# See if it's a public port
        		secapps = Fog::Compute[:oraclecloud].security_applications.all_public
        		public_app = secapps.detect { |app| 
        			Float(app.dport || 0) == port }
        		if public_app then
        			secapp = public_app.name
        		else
        			begin
        				custom_app = Fog::Compute[:oraclecloud].security_applications.get("#{name}_#{port}")
        			rescue Fog::Compute::OracleCloud::NotFound		

	        			# Create custom security application
	        			custom_app = Fog::Compute[:oraclecloud].security_applications.create(
	        				:name => "#{name}_#{port}",
	        				:protocol => 'tcp',
	        				:dport => port
	        			)
	        		end
        			secapp = custom_app.name
        		end
        	else
        		# They want to use a named security application
        		# TODO: Add support for user created security apps
        		secapp = '/oracle/public/' + port
        	end
        	block = /\d{,2}|1\d{2}|2[0-4]\d|25[0-5]/
					re = /\A#{block}\.#{block}\.#{block}\.#{block}\z/

        	if re =~ list then 
        		# They sent an ip address. Create new security ip list
        		# Check if it exists already (assume this has been run before)
        		begin
        			seclist = Fog::Compute[:oraclecloud].security_ip_lists.get("#{name}_#{list}")
        		rescue Fog::Compute::OracleCloud::NotFound		
	        		Fog::Logger.debug "Creating Security IP List for #{list}"
	        		seclist = Fog::Compute[:oraclecloud].security_ip_lists.create(
	        			:name => "#{name}_#{list}",
	        			:secipentries => [list]
	        		)
	        	end
						list_name = "seciplist:#{name}_#{list}"        		
        	else
        		list_name = list
        	end
        	begin
        		rule = Fog::Compute[:oraclecloud].security_rules.get(rule_name)
        	rescue Fog::Compute::OracleCloud::NotFound		
	        	Fog::Logger.debug "Creating Security Rule for #{list_name} to #{name} (app:#{port})"
	        	rule = Fog::Compute[:oraclecloud].security_rules.create(
	        		:application => secapp,
	        		:name => rule_name,
	        		:src_list => list_name,
	        		:dst_list => "seclist:#{name}" 
	        	) 
	        end
	        rule
        end
	    end
	  end
  end
end
