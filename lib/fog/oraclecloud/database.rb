module Fog
  module OracleCloud
    class Database < Fog::Service
      requires :oracle_username, :oracle_password, :oracle_domain
      recognizes :oracle_region

      model_path	'fog/oraclecloud/models/database'
      model				:instance
      collection	:instances
      model       :backup
      collection  :backups
      model       :recovery
      collection  :recoveries
      model       :snapshot
      collection  :snapshots
      model       :server
      collection  :servers
      model       :patch
      collection  :patches

			request_path 'fog/oraclecloud/requests/database'
      request :list_instances
      request :get_instance
      request :get_instance_from_job
      request :create_instance
      request :delete_instance
      request :list_backups
      request :list_recoveries
      request :list_snapshots
      request :get_snapshot
      request :create_snapshot
      request :delete_snapshot
      request :list_servers
      request :scale_instance
      request :backup_instance
      request :recover_instance
      request :list_patches

      class Real

      	def initialize(options={})
      		@username = options[:oracle_username]
      		@password = options[:oracle_password]
      		@identity_domain   = options[:oracle_domain]
          region_url = options[:oracle_region] == 'emea' ? 'https://dbcs.emea.oraclecloud.com' : 'https://dbaas.oraclecloud.com'
          Excon.ssl_verify_peer = false

          @connection = Fog::XML::Connection.new(region_url)
      	end

        def username
          @username
        end

        def password
          @password
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
              Fog::OracleCloud::Database::NotFound.slurp(error)
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
        end

        def username
          @username
        end

        def password
          @password
        end

        def self.data 
          @data ||= {
            :instances  => {},
            :snapshots  => {},
            :servers    => {},
            :backups    => {},
            :recoveries => {},
            :deleted_at => {},
            :created_at => {},
            :maintenance_at => {}
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
