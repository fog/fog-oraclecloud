require 'fog/core/collection'

module Fog
  module OracleCloud
    class Monitoring
      class MetricsReports < Fog::Collection

      	model Fog::OracleCloud::Monitoring::MetricsReport

      	def all
          data = service.list_metrics_reports().body['items']
          pp data
          load(data)
        end

        def get(service_name)
          new(service.get_instance(service_name).body)
        end

      end
    end

  end
end
