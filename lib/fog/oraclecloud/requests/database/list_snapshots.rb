module Fog
  module OracleCloud
    class Database
      class Real
      	def list_snapshots(db_name)
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/dbaas/instances/#{db_name}/snapshots"
          )
          response
        end
      end

      class Mock
        def list_snapshots(db_name)
          response = Excon::Response.new

          snapshots = self.data[:snapshots][db_name].values

          response.body = snapshots
          response
        end
      end
    end
  end
end
