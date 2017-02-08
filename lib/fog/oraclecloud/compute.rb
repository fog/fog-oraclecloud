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
						response = @connection.request(params.merge!({
							:headers  => {
								'Cookie' => @auth_cookie
							}.merge!(params[:headers] || {})
						}), &block)
					rescue Excon::Errors::HTTPStatusError => error
						raise case error
						when Excon::Errors::NotFound
              puts "not found"
							Fog::Compute::OracleCloud::NotFound.slurp(error)
						when Excon::Errors::Conflict
							data = Fog::JSON.decode(error.response.body)
							raise Error.new(data['message'])
						else
              puts "else"
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