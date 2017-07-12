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
        	requires :name, :sshkeys
          
          data = service.create_instance(name, shape || 'oc3', imagelist || '/oracle/public/oel_6.4_2GB_v1', label, sshkeys)
          merge_attributes(data.body['instances'][0])
        end

        def destroy
        	requires :name
        	service.delete_instance(name)
        end

        def get_security_lists
        	seclists = []
        	networking['eth0']['seclists'].each do |seclist| 
        		seclists.push(Fog::Compute[:oraclecloud].security_lists.new({
        			'name'=>seclist
        		}))
        	end
        	seclists
        end

        def create_security_list(seclist_name=nil, description=nil, policy="deny", outbound_policy="permit")
        	if !seclist_name then
        		seclist_name = "#{name}_SecList"
        	end
        	data = Fog::Compute[:oraclecloud].security_lists.create(
        		:name => seclist_name,
        		:description => description,
        		:policy => policy,
        		:outbound_cidr_policy => outbound_policy
        	)
        	# Now attach to this instance
        	Fog::Compute[:oraclecloud].security_associations.create(
        		:name => "#{name}_SecAssoc",
        		:seclist => seclist_name,
        		:vcable => vcable_id
        	)
        	data
        end

        def get_public_ip_address
        	if !networking['eth0'] or !networking['eth0']['nat'] or !networking['eth0']['nat'].include? 'ipreservation:' then
        		# Instance doesn't have a public ip reservation yet
        		return false
        	end
        	ip_name = networking['eth0']['nat'].sub "ipreservation:", ''
        	ip = Fog::Compute[:oraclecloud].ip_reservations.get(ip_name)
        	ip.ip
        end

        def add_public_ip_address
        	existing = get_public_ip_address 
        	if existing then
        		raise ArgumentError.new "Can't add public id address to instance that already has one (#{existing.ip})"
        	end
        	begin 
        		ip = Fog::Compute[:oraclecloud].ip_reservations.get("#{name}_publicIp")
        	rescue Fog::Compute::OracleCloud::NotFound    
        		# Doesn't exist yet. Create it now
	        	ip = Fog::Compute[:oraclecloud].ip_reservations.create(
	        		:name => "#{name}_publicIp"
	        	)
	        end
        	# Attach it to this instance
        	Fog::Logger.debug "Associating IP Reservation (#{name}_publicIp) with vcable: #{vcable_id}"
        	assoc = Fog::Compute[:oraclecloud].ip_associations.create(
        		:parentpool => "ipreservation:#{name}_publicIp",
        		:vcable => vcable_id
        	)
        	Fog::Logger.debug "Created IP Association - #{assoc.uri}"
        	ip
        end
	    end
	  end
  end
end
