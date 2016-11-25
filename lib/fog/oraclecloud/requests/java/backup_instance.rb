module Fog
  module OracleCloud
    class Java
      class Real

      	def backup_instance(service_name, options={})
          # Oracle Cloud requires an empty JSON object in the body
          body_data = {
            'databaseIncluded' => options[:databaseIncluded],
            'expirationDate' => options[:expirationDate],
            'full' =>  options[:full],
            'notes' => options[:notes]
          }
          body_data = body_data.reject {|key, value| value.nil?}
        
          response = request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/backups",
            :body     => Fog::JSON.encode(body_data),
          )
          
          response
        end
      end

      class Mock
        def backup_instance(service_name)
      		response = Excon::Response.new

          if !self.data[:backups].is_a? Array 
            self.data[:backups] = []
          end
          
          self.data[:backups].push({
            'backupId'=>'999',
            'backupStartDate'=>Time.now.strftime('%d-%b-%Y %H:%M:%S UTC'),
            'dbTag'=>'TAG' + Time.now.strftime('%Y%m%dT%H%M%S'),
            'status'=>'Completed',
            'service_name'=>service_name
          })
          
          response.status = 202
          response.body ={
            'operationName'=>'start-backup'
          }
          response
      	end
      end
    end
  end
end
