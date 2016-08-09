module Fog
  module Oracle
    class Database < Fog::Service
      requires :oracle_username, :oracle_password, :oracle_domain, :oracle_region

      model_path	'fog/oracle/models/database'
      model				:instance
      collection	:instances

			request_path 'fog/oracle/requests/database'
      request :list_instances
      request :get_instance
      request :create_instance
      request :delete_instance

      class Real

      	def initialize(options={})
      		@username = options[:oracle_username]
      		@password = options[:oracle_password]
      		@identity_domain   = options[:oracle_domain]
          region_url = options[:oracle_region] == 'emea' ? 'https://dbcs.emea.oraclecloud.com' : 'https://dbaas.oraclecloud.com'
          Excon.ssl_verify_peer = false

          @connection = Fog::XML::Connection.new(region_url)
      	end

      	def auth_header
        	auth_header ||= 'Basic ' + Base64.encode64("#{@username}:#{@password}").gsub("\n",'')
      	end

        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Authorization' => auth_header,
                'X-ID-TENANT-NAME' => @identity_domain,
                'Content-Type' => 'application/json',
                #'Accept'       => 'application/json'
              }.merge!(params[:headers] || {})
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Oracle::Database::NotFound.slurp(error)
            else
              error
            end
          end
          #https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/agriculture/status/create/job/2781084
          if !response.body.empty? && parse_json
            # The Oracle Cloud doesn't return the Content-Type header as application/json, rather as application/vnd.com.oracle.oracloud.provisioning.Pod+json
            # Should add check here to validate, but not sure if this might change in future
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

          @connection = Fog::XML::Connection.new("https://dbaas.oraclecloud.com")
        end

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :instances    => {}
            }
          end
        end

        def data
          self.class.data[@oracle_username]
        end
        
        # Remove, jsut for testing
        def auth_header
          auth_header ||= 'Basic ' + Base64.encode64("#{@username}:#{@password}").gsub("\n",'')
        end
        def request(params, parse_json = true, &block)
          begin
            response = @connection.request(params.merge!({
              :headers  => {
                'Authorization' => auth_header,
                'X-ID-TENANT-NAME' => @identity_domain,
                'Content-Type' => 'application/json',
                #'Accept'       => 'application/json'
              }.merge!(params[:headers] || {})
            }), &block)
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Oracle::Database::NotFound.slurp(error)
            else
              error
            end
          end
          #https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/agriculture/status/create/job/2781084
          if !response.body.empty? && parse_json
            # The Oracle Cloud doesn't return the Content-Type header as application/json, rather as application/vnd.com.oracle.oracloud.provisioning.Pod+json
            # Should add check here to validate, but not sure if this might change in future
            response.body = Fog::JSON.decode(response.body)
          end
          response
        end
      end
    end
  end
end
