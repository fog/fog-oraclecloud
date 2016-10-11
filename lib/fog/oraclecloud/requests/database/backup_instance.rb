module Fog
  module OracleCloud
    class Database
      class Real

      	def backup_instance(service_name)
          # Oracle Cloud requires an empty JSON object in the body
          body_data     = {}
        
          response = request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/backups",
            :body     => Fog::JSON.encode(body_data),
          )
          response.database_id = service_name
          response
        end
      end

      class Mock
        def backup_instance(service_name)
      		response = Excon::Response.new

          if !self.data[:backups][service_name].is_a? Array then 
            self.data[:backups][service_name] = []
            self.data[:created_at][service_name] = []
          end
          self.data[:backups][service_name].push({
            'backupCompleteDate'=>Time.now.strftime('%d-%b-%Y %H:%M:%S UTC'),
            'dbTag'=>'TAG' + Time.now.strftime('%Y%m%dT%H%M%S'),
            'status'=>'IN PROGRESS',
            'database_id'=>service_name
          })
          self.data[:created_at][service_name].push(Time.now)
          response.status = 202
          response
      	end
      end
    end
  end
end
