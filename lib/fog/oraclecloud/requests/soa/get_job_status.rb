module Fog
  module OracleCloud
    class SOA
      class Real

      	def get_job_status(type, job_id)
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/paas/service/soa/api/v1.1/instances/#{@identity_domain}/status/#{type}/job/#{job_id}"
          )
          response.body['message']
        end
      end

      class Mock
        def get_job_status(type, job_id)
          ['Creation job succeded']
        end
      end
    end
  end
end