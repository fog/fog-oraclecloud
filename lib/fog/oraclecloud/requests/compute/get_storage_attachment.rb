module Fog
  module Compute
    class OracleCloud
      class Real
				def get_storage_attachment(name)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/storage/attachment/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def get_storage_attachment(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''

          if sa = self.data[:storage_attachments][clean_name] 
            response.status = 200
            response.body = sa
            response
          else;
            raise Fog::Compute::OracleCloud::NotFound.new("Storage Attachment #{name} does not exist");
          end
        end
      end
    end
  end
end
