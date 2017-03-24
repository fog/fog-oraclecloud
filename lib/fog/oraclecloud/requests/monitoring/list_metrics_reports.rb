module Fog
  module OracleCloud
    class Monitoring
      class Real
      	def list_metrics_reports
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/monitoring/monitoring/#{@identity_domain}/.customer/api/v1/metricReports"
          )
          response
        end
      end

      class Mock
        def list_instances
          response = Excon::Response.new

          #instances = self.data[:instances].values

          response.body = {
            'items' => []
          }
          response
        end
      end
    end
  end
end
