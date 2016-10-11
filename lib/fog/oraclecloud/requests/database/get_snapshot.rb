module Fog
  module OracleCloud
    class Database
      class Real

      	def get_snapshot(db_name, snapshot_name)
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/dbaas/instances/#{db_name}/snapshots/#{snapshot_name}"
          )
          response
        end
      end

      class Mock
        def get_snapshot(db_name, snapshot_name)
          response = Excon::Response.new

          if snapshot = self.data[:snapshots][db_name][snapshot_name]
            case snapshot['status']
            when 'Terminating'
              if Time.now - self.data[:deleted_at][snapshot_name] >= Fog::Mock.delay
                self.data[:deleted_at].delete(snapshot_name)
                self.data[:snapshots][db_name].delete(snapshot_name)
              end
            when 'In Progress'
              if Time.now - self.data[:created_at][snapshot_name] >= Fog::Mock.delay
                self.data[:snapshots][db_name][snapshot_name]['status'] = 'Succeeded'
                snapshot = self.data[:snapshots][db_name][snapshot_name]
                self.data[:created_at].delete(snapshot_name)
              end
            end
            response.status = 200
            response.body = snapshot
            response
          else
            raise Fog::OracleCloud::Database::NotFound.new("Snapshot #{snapshot_name} for #{db_name} does not exist");
          end
        end
      end
    end
  end
end