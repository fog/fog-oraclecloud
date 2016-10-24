module Fog
  module OracleCloud
    class Database
      class Real

      	def get_instance_from_job(job_id)
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/dbcs/api/v1.1/instances/#{@identity_domain}/status/create/#{job_id}"
          )
          response
        end
      end

      class Mock
        def get_instance_from_job(job_id)
          response = Excon::Response.new

          instance = self.data[:instances].select { |k, v| v['creation_job_id'] == job_id }
          if instance
            response.status = 200
            response.body = instance
            response
          else
            raise Fog::OracleCloud::Database::NotFound.new("Database #{job_id} does not exist");
          end
        end
      end
    end
  end
end