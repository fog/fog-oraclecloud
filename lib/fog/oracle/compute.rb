module Fog
	module Compute
		class Oracle < Fog::Service
			requires :oracle_username, :oracle_password, :oracle_domain, :oracle_compute_api

      model_path	'fog/oracle/models/compute'
    	model :security_application
    	collection :security_applications

			model :security_rule
    	collection :security_rules

			model :security_list
    	collection :security_lists

      model :image
      collection :images

			request_path 'fog/oracle/requests/compute'
     	request :list_security_applications
     	request :create_security_application
     	request :delete_security_application
     	request :get_security_application

 			request :list_security_rules
     	request :create_security_rule
     	request :delete_security_rule
     	request :get_security_rule

 			request :list_security_lists

      request :list_images
      request :get_image
      request :create_image

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
							Fog::Oracle::Java::NotFound.slurp(error)
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
    end
  end
end