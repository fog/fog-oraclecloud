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
          
          if backup = self.data[:backups].first       
            response.status = 200           
            response.body =  backup
            response
          else
            raise Fog::OracleCloud::Java::NotFound.new("Java Server #{name} does not exist");
          end
        end
      end
    end
  end
end
