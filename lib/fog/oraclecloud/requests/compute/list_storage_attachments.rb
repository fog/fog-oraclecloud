module Fog
  module Compute
    class OracleCloud
      class Real
      	def list_storage_attachments
          response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/storage/attachment/Compute-#{@identity_domain}/#{@username}/"
          )
          response
        end
      end

      class Mock
        def list_storage_attachments
          response = Excon::Response.new

          sas = self.data[:storage_attachments].values
          response.body = {
            'result' => sas
          }
          response
        end
      end
    end
  end
end
