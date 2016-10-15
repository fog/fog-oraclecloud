module Fog
  module OracleCloud
    class Database
      class Real
      	def list_backups(db_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{db_name}/backups"
          )
          response
        end
      end

      class Mock
        def list_backups(db_name)
          response = Excon::Response.new

          if !self.data[:backups][db_name] then self.data[:backups][db_name] = [] end
          backups = self.data[:backups][db_name]

          backups.each_with_index { |b, i| 
            if b['status'] = 'IN PROGRESS' then
              if Time.now - self.data[:created_at][:backups][db_name][i] >= Fog::Mock.delay
                self.data[:created_at][:backups][db_name].delete(i)
                self.data[:backups][db_name][i]['status'] = 'COMPLETED'
                b = self.data[:backups][db_name][i]
              end
            end
          }
          response.body = {
            'backupList' => backups
          }
          response
        end
      end
    end
  end
end
