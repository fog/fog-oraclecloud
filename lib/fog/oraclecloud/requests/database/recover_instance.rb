module Fog
  module OracleCloud
    class Database
      class Real

      	def recover_instance(service_name, type=nil, value=nil)
          if type == 'latest' then body_data = { 'latest' => true } end
          if type == 'tag' then body_data = { 'tag' => value } end
          if type == 'timestamp' then body_data = { 'timestamp' => value } end
          if type == 'scn' then body_data = { 'scn' => value } end
        
          response = request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/backups/recovery",
            :body     => Fog::JSON.encode(body_data),
          )
          response.database_id = service_name
          response
        end
      end

      class Mock
        def recover_instance(service_name, type=nil, value=nil)
      		response = Excon::Response.new

          if !self.data[:recoveries][service_name].is_a? Array then 
            self.data[:recoveries][service_name] = []
          end

          if !self.data[:created_at][:recoveries] 
            self.data[:created_at][:recoveries] = {}
            self.data[:created_at][:recoveries][service_name] = []
          end

          # Find the backup first
          backups = self.data[:backups][service_name]
          backup = nil
          if type == 'tag' then
            backup = backups.find { |b| b['dbTag'] = value }
          elsif type == 'timestamp' then
            # Too hard to do this logic in mock. Just return the latest
            backup = backups.last
          elsif type.nil? then
            # Default to searching for the latest
            backup = backups.last
          end
          if backup.nil? then
            response.status = 500
          else
            if type == 'tag' then
              self.data[:recoveries][service_name].push({
                'recoveryStartDate'=>Time.now.strftime('%d-%b-%Y %H:%M:%S UTC'),
                'status'=>'IN PROGRESS',
                'dbTag'=>value,
                'database_id' => service_name
              })
              self.data[:created_at][:recoveries][service_name].push(Time.now)
            elsif type == 'timestamp' then
              self.data[:recoveries][service_name].push({
                'recoveryStartDate'=>Time.now.strftime('%d-%b-%Y %H:%M:%S UTC'),
                'status'=>'IN PROGRESS',
                'timestamp'=>value.strftime('%d-%b-%Y %H:%M:%S'),
                'database_id' => service_name
              })
              self.data[:created_at][:recoveries][service_name].push(Time.now)
            elsif type.nil? then
              self.data[:recoveries][service_name].push({
                'recoveryStartDate'=>Time.now.strftime('%d-%b-%Y %H:%M:%S UTC'),
                'status'=>'IN PROGRESS',
                'latest'=>true,
                'database_id' => service_name
              })
              self.data[:created_at][:recoveries][service_name].push(Time.now)
            end
            response.status = 202
          end
          response
      	end
      end
    end
  end
end
