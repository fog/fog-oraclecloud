module Fog
  module OracleCloud
    class Java
      class Real
      	def get_backup(service_name, backup_id)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/jcs/api/v1.1/instances/#{@identity_domain}/#{service_name}/backups/#{backup_id}"
          )
          response
        end
      end

      class Mock
        def get_backup(service_name, backup_id)
          response = Excon::Response.new
          
          backup = {}
          self.data[:backups].each_with_index { |r, i| 
            if r['backupId'].eql?(backup_id)
              backup = self.data[:backups][i]
            end
          }
              
          response.status = 200           
          response.body =  backup
          response
          
        end
      end
    end
  end
end
