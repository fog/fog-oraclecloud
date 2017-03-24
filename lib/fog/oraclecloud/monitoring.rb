module Fog
  module OracleCloud
    class Monitoring < Fog::Service
      requires :oracle_username, :oracle_password, :oracle_domain
      recognizes :oracle_region
      
      model_path	'fog/oraclecloud/models/monitoring'
      model				:metrics_report
      collection	:metrics_reports
     

			request_path 'fog/oraclecloud/requests/monitoring'
      request :list_metrics_reports
     

      class Real

      	def initialize(options={})
      		@username = options[:oracle_username]
      		@password = options[:oracle_password]
      		@identity_domain   = options[:oracle_domain]
          region = options[:oracle_region].nil? ? 'us' : options[:oracle_region]
          url = "https://monitoring.#{region}.oraclecloud.com"
          Excon.ssl_verify_peer = false
          @connection = Fog::XML::Connection.new(url)
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
          pp @connection
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
							Fog::OracleCloud::Java::NotFound.slurp(error)
						else
							error
						end
					end
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

        def region_url
          @region_url
        end

        def self.data 
          @data ||= {
          
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
