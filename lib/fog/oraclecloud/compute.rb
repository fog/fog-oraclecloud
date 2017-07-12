module Fog
	module Compute
		class OracleCloud < Fog::Service
			requires :oracle_username, :oracle_password, :oracle_domain, :oracle_compute_api

      model_path	'fog/oraclecloud/models/compute'
    	model :security_application
    	collection :security_applications

			model :security_rule
    	collection :security_rules

      model :security_list
      collection :security_lists

      model :security_ip_list
      collection :security_ip_lists

      model :security_association
      collection :security_associations

      model :image
      collection :images

      model :image_list
      collection :image_lists

      model :instance
      collection :instances

      model :ssh_key
      collection :ssh_keys

      model :object_plan
      collection :object_plans
      model :orchestration
      collection :orchestrations

      model :volume
      collection :volumes

      model :ip_reservation
      collection :ip_reservations
      model :ip_network
      collection :ip_networks
      model :ip_association
      collection :ip_associations

      model :storage_attachment
      collection :storage_attachments

			request_path 'fog/oraclecloud/requests/compute'
     	request :list_security_applications
     	request :create_security_application
     	request :delete_security_application
     	request :get_security_application

 			request :list_security_rules
     	request :create_security_rule
     	request :delete_security_rule
     	request :get_security_rule

      request :list_security_lists
      request :create_security_list
      request :get_security_list
      request :delete_security_list

      request :create_security_ip_list
      request :get_security_ip_list

      request :get_image
      request :create_image
      request :delete_image
      request :list_images

      request :list_image_lists
      request :get_image_list
      request :create_image_list
      request :update_image_list
      request :delete_image_list

      request :list_instances
      request :get_instance
      request :create_instance
      request :delete_instance

      request :list_ssh_keys
      request :get_ssh_key
      request :create_ssh_key
      request :delete_ssh_key
      request :update_ssh_key

      request :get_orchestration
      request :list_orchestrations
      request :create_orchestration
      request :update_orchestration
      request :delete_orchestration
      request :start_orchestration
      request :stop_orchestration

      request :list_volumes
      request :create_volume

      request :list_ip_reservations
      request :get_ip_reservation
      request :create_ip_reservation
      request :delete_ip_reservation
      request :update_ip_reservation

      request :create_ip_association
      request :list_ip_associations
      request :get_ip_association

      request :list_ip_networks
      request :get_ip_network
      request :create_ip_network
      request :delete_ip_network

      request :list_storage_attachments
      request :get_storage_attachment
      request :create_storage_attachment

      request :create_security_association

			class Real

      	def initialize(options={})
      		@username = options[:oracle_username]
      		@password = options[:oracle_password]
      		@identity_domain   = options[:oracle_domain]
      		@api_endpoint   = options[:oracle_compute_api]

          @connection = Fog::XML::Connection.new(@api_endpoint)

          # Get authentication token
          authenticate
      	end

      	def authenticate()
      		begin
            response = @connection.request({
            	:expects  => 204,
          	  :method   => 'POST',
            	:path     => "/authenticate/",
            	:headers  => {
            		'Content-Type'	=> 'application/oracle-compute-v3+json'
            	},
            	:body			=> Fog::JSON.encode({
            		'user' 		=> "/Compute-#{@identity_domain}/#{@username}",
            		'password'=> @password
            	})
            })
          rescue Excon::Errors::HTTPStatusError => error
            error
          end
          if response.nil? || !response.headers['Set-Cookie'] then
          	raise Error.new('Could not authenticate to Compute Cloud Service. Check your athentication details in your config')
          end
          @auth_cookie = response.headers['Set-Cookie']
      	end

      	def request(params, parse_json = true, &block)
					begin
            Fog::Logger.debug("Sending #{params[:body].to_s} to #{params[:path]}")
						response = @connection.request(params.merge!({
							:headers  => {
								'Cookie' => @auth_cookie
							}.merge!(params[:headers] || {})
						}), &block)
					rescue Excon::Errors::HTTPStatusError => error
						raise case error
						when Excon::Errors::NotFound
							Fog::Compute::OracleCloud::NotFound.slurp(error)
						when Excon::Errors::Conflict
							data = Fog::JSON.decode(error.response.body)
							raise Error.new(data['message'])
						else
							error
						end
					end
					if !response.body.empty? && parse_json
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end

      class Mock
        def initialize(options={})
          @username = options[:oracle_username]
          @password = options[:oracle_password]
          @identity_domain   = options[:oracle_domain]
          @api_endpoint   = options[:oracle_compute_api]
        end

        def self.data 
          @data ||= {
            :instances => {},
            :sshkeys => {},
            :orchestrations => {},
            :ip_reservations => {},
            :ip_networks => {},
            :ip_associations => {},
            :storage_attachments => {},
            :security_lists => {},
            :security_ip_lists => {},
            :security_rules => {},
            :security_associations => {},
            :security_applications => {
              "/oracle/public/all" => {
                "protocol"=>"all",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/all",
                "icmptype"=>"",
                "value2"=>0,
                "value1"=>0,
                "dport"=>nil,
                "icmpcode"=>"",
                "id"=>"cacb38ff-ecbc-4bb5-9ce2-a30f57515719",
                "name"=>"/oracle/public/all",
              },
              "/oracle/public/cloudservice"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/cloudservice",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>5020,
                "dport"=>"5020",
                "icmpcode"=>"",
                "id"=>"1a74b578-88be-4f0f-87b9-a81e69a5cc8f",
                "name"=>"/oracle/public/cloudservice"
              },
              "/oracle/public/dns-tcp"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/dns-tcp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>53,
                "dport"=>"53",
                "icmpcode"=>"",
                "id"=>"e50b2a1c-4ac8-4219-9c33-7150fbf5918c",
                "name"=>"/oracle/public/dns-tcp"
              },
              "/oracle/public/dns-udp"=>{
                "protocol"=>"udp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/dns-udp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>53,
                "dport"=>"53",
                "icmpcode"=>"",
                "id"=>"f91fa982-c40c-4f1f-aa0b-58a28f94405a",
                "name"=>"/oracle/public/dns-udp"
              },
              "/oracle/public/http"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/http",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>80,
                "dport"=>"80",
                "icmpcode"=>"",
                "id"=>"65c55823-1899-4901-9eef-1aaa1a8a2048",
                "name"=>"/oracle/public/http"
              },
              "/oracle/public/https"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/https",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>443,
                "dport"=>"443",
                "icmpcode"=>"",
                "id"=>"8b1dae32-1432-4d67-9c90-4df06dfd446c",
                "name"=>"/oracle/public/https"
              },
              "/oracle/public/icmp"=>{
                "protocol"=>"icmp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/icmp",
                "icmptype"=>"",
                "value2"=>255,
                "value1"=>255,
                "dport"=>nil,
                "icmpcode"=>"",
                "id"=>"86259853-843b-4198-8655-776c70a51c42",
                "name"=>"/oracle/public/icmp"
              },
              "/oracle/public/ldap"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/ldap",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>389,
                "dport"=>"389",
                "icmpcode"=>"",
                "id"=>"6964cc80-9a97-43ef-b436-2df594f0bc20",
                "name"=>"/oracle/public/ldap"
              },
              "/oracle/public/ldaps"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/ldaps",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>636,
                "dport"=>"636",
                "icmpcode"=>"",
                "id"=>"36004553-f14c-4894-a2be-77844916bc47",
                "name"=>"/oracle/public/ldaps"
              },
              "/oracle/public/mail"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/mail",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>25,
                "dport"=>"25",
                "icmpcode"=>"",
                "id"=>"62dbdede-50df-4ce3-b1d8-3194b535c208",
                "name"=>"/oracle/public/mail"
              },
              "/oracle/public/mysql"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/mysql",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>3306,
                "dport"=>"3306",
                "icmpcode"=>"",
                "id"=>"5bbf54ed-cfde-4e85-9b9a-338500806550",
                "name"=>"/oracle/public/mysql"
              },
              "/oracle/public/nfs"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/nfs",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>2049,
                "dport"=>"2049",
                "icmpcode"=>"",
                "id"=>"7ba2f9e4-7846-487a-a6d1-236ad42a09d1",
                "name"=>"/oracle/public/nfs"
              },
              "/oracle/public/ntp-tcp"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/ntp-tcp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>123,
                "dport"=>"123",
                "icmpcode"=>"",
                "id"=>"2796dc84-12c4-43d1-9737-929dbbbb3901",
                "name"=>"/oracle/public/ntp-tcp"
              },
              "/oracle/public/ntp-udp"=>{
                "protocol"=>"udp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/ntp-udp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>123,
                "dport"=>"123",
                "icmpcode"=>"",
                "id"=>"69c16c96-6f0d-427b-9af6-e0709926c2c1",
                "name"=>"/oracle/public/ntp-udp"
              },
              "/oracle/public/ping-reply"=>{
                "protocol"=>"icmp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/ping-reply",
                "icmptype"=>"reply",
                "value2"=>0,
                "value1"=>0,
                "dport"=>nil,
                "icmpcode"=>"",
                "id"=>"a3542c2e-fd2d-47de-aa74-9ad4e49e949c",
                "name"=>"/oracle/public/ping-reply"
              },
              "/oracle/public/pings"=>{
                "protocol"=>"icmp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/pings",
                "icmptype"=>"echo",
                "value2"=>0,
                "value1"=>8,
                "dport"=>nil,
                "icmpcode"=>"",
                "id"=>"0f5f4cdf-3ce3-4e35-8eb4-18014f865c66",
                "name"=>"/oracle/public/pings"
              },
              "/oracle/public/rdp"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/rdp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>3389,
                "dport"=>"3389",
                "icmpcode"=>"",
                "id"=>"6e926962-1f63-4c11-a284-9b8faabf25ac",
                "name"=>"/oracle/public/rdp"
              },
              "/oracle/public/rpcbind"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/rpcbind",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>111,
                "dport"=>"111",
                "icmpcode"=>"",
                "id"=>"5f0228de-a2f0-4324-a1a3-d360da71a710",
                "name"=>"/oracle/public/rpcbind"
              },
              "/oracle/public/rsync"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/rsync",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>873,
                "dport"=>"873",
                "icmpcode"=>"",
                "id"=>"56df210e-326f-43a5-8625-4388c79dc219",
                "name"=>"/oracle/public/rsync"
              },
              "/oracle/public/snmp-tcp"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/snmp-tcp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>161,
                "dport"=>"161",
                "icmpcode"=>"",
                "id"=>"e9c3278a-6001-48c8-a6d6-333942c2ff77",
                "name"=>"/oracle/public/snmp-tcp"
              },
              "/oracle/public/snmp-trap-tcp"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/snmp-trap-tcp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>162,
                "dport"=>"162",
                "icmpcode"=>"",
                "id"=>"986f0200-e7ff-445a-8961-7be4581e1dc3",
                "name"=>"/oracle/public/snmp-trap-tcp"
              },
              "/oracle/public/snmp-trap-udp"=>{
                "protocol"=>"udp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/snmp-trap-udp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>162,
                "dport"=>"162",
                "icmpcode"=>"",
                "id"=>"580979e4-4c4d-4828-96c0-ba80703539ae",
                "name"=>"/oracle/public/snmp-trap-udp"
              },
              "/oracle/public/snmp-udp"=>{
                "protocol"=>"udp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/snmp-udp",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>161,
                "dport"=>"161",
                "icmpcode"=>"",
                "id"=>"143be719-8a16-4a57-9386-192778557cb8",
                "name"=>"/oracle/public/snmp-udp"
              },
              "/oracle/public/squid"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/squid",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>3128,
                "dport"=>"3128",
                "icmpcode"=>"",
                "id"=>"0e0563e8-e4c1-46de-b151-882c911e1eff",
                "name"=>"/oracle/public/squid"
              },
              "/oracle/public/ssh"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/ssh",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>22,
                "dport"=>"22",
                "icmpcode"=>"",
                "id"=>"d19fbaa7-59cf-49e6-83ad-d6d9fc4454cd",
                "name"=>"/oracle/public/ssh"
              },
              "/oracle/public/tcp5900"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/tcp5900",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>5900,
                "dport"=>"5900",
                "icmpcode"=>"",
                "id"=>"eeed882e-1ce0-4256-8d87-47f7264b8191",
                "name"=>"/oracle/public/tcp5900"
              },
              "/oracle/public/telnet"=>{
                "protocol"=>"tcp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/telnet",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>23,
                "dport"=>"23",
                "icmpcode"=>"",
                "id"=>"146a98f8-5e7e-4e7e-86c8-6d34fab52318",
                "name"=>"/oracle/public/telnet"
              },
              "/oracle/public/udp443"=>{
                "protocol"=>"udp",
                "description"=>"",
                "uri"=>
                 "#{@api_endpoint}/secapplication/oracle/public/udp443",
                "icmptype"=>"",
                "value2"=>-1,
                "value1"=>443,
                "dport"=>"443",
                "icmpcode"=>"",
                "id"=>"64b4369b-9d7f-4bc4-86dd-85ba77ea9a3f",
                "name"=>"/oracle/public/udp443"
              }
            },
            :image_lists => {
              "/oracle/public/Oracle_Linux_7" => {
                "name" => "/oracle/public/Oracle_Linux_7",
                "default" => 1,
                "description" => "Oracle Linux 7",
                "entries" =>[{
                  "attributes" => {},
                  "version" => 1,
                  "machineimages" => ["/oracle/public/OracleLinux7"],
                  "uri" => "https://@api_endpoint:443/imagelist/oracle/public/OracleLinux7"
                }]
              }
            },
            :deleted_at => {}
          }
        end

        def self.reset
          @data = nil
        end

        def data 
          self.class.data
        end
      end
    end
  end
end