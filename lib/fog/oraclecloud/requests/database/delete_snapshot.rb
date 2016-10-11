module Fog
  module OracleCloud
    class Database
      class Real

        def delete_snapshot(db_name, snapshot_name)
          request(
            :method   => 'DELETE',
            :expects  => 202,
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/dbaas/instances/#{db_name}/snapshots/#{snapshot_name}"
          )
        end
      end

     class Mock
        def delete_snapshot(db_name, snapshot_name)
          response = Excon::Response.new
          self.data[:snapshots][db_name][snapshot_name]['status'] = 'Terminating'
          self.data[:deleted_at][snapshot_name] = Time.now
          response.status = 204
          response
        end
      end
    end
  end
end
