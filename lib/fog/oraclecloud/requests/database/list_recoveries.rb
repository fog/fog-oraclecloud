module Fog
  module OracleCloud
    class Database
      class Real
      	def list_recoveries(db_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/#{db_name}/backups/recovery/history"
          )
          response
        end
      end

      class Mock
        def list_recoveries(db_name)
          response = Excon::Response.new

          recoveries = self.data[:recoveries][db_name]
          recoveries.each_with_index { |r, i| 
            if r['status'] = 'IN PROGRESS' then
              if Time.now - self.data[:created_at][:recoveries][db_name][i] >= Fog::Mock.delay
                self.data[:created_at][:recoveries][db_name].delete(i)
                self.data[:recoveries][db_name][i]['status'] = 'COMPLETED'
                self.data[:recoveries][db_name][i]['recoveryCompleteDate'] = Time.now.strftime('%d-%b-%Y %H:%M:%S UTC')
                b = self.data[:backups][db_name][i]
              end
            end
          }
          response.body = {
            'recoveryList' => recoveries
          }
          response
        end
      end
    end
  end
end
