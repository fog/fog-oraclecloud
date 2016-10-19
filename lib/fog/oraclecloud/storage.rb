module Fog
	module Storage
		class OracleCloud < Fog::Service
			requires :oracle_username, :oracle_password, :oracle_domain, :oracle_storage_api

			model_path 'fog/oraclecloud/models/storage'
			collection :containers
			model :container
      collection :objects
      model :object

			request_path 'fog/oraclecloud/requests/storage'
			request :list_containers
			request :create_container
      request :get_container
      request :delete_container

			class Real
      	def initialize(options={})
      		@username = options[:oracle_username]
      		@password = options[:oracle_password]
      		@identity_domain   = options[:oracle_domain]
      		@api_endpoint   = options[:oracle_storage_api]

          @connection = Fog::XML::Connection.new(@api_endpoint)

          # Get authentication token
          authenticate
      	end

      	def authenticate()

      		begin
            response = @connection.request({
            	:expects  => 200,
          	  :method   => 'GET',
            	:path     => "auth/v1.0",
            	:headers  => {
                'X-Storage-User'  => "Storage-#{@identity_domain}:#{@username}",
                'X-Storage-Pass' => @password
            	}
            })
          rescue Excon::Errors::HTTPStatusError => error
            error
          end
          if response.nil? || !response.headers['X-Auth-Token'] then
          	raise Error.new('Could not authenticate to Storage Cloud Service. Check your athentication details in your config')
          end
          @auth_token = response.headers['X-Auth-Token']
      	end

      	def request(params, parse_json = true, &block)
					begin
						response = @connection.request(params.merge!({
							:headers  => {
								'X-Auth-Token' => @auth_token
							}.merge!(params[:headers] || {})
						}), &block)
					rescue Excon::Errors::HTTPStatusError => error
						raise case error
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
            :containers => {}
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