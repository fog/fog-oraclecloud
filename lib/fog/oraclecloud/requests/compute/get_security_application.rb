module Fog
  module Compute
    class OracleCloud
      class Real
				def get_security_application(name)
          path = "/secapplication"
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          if name.include? '/oracle/public' then
            path += "/#{name}/"
          else 
            path += "/Compute-#{@identity_domain}/#{@username}/#{name}/"
          end
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => path,
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end
      class Mock
        def get_security_application(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''
          if app = self.data[:security_applications][clean_name] 
            response.status = 200
            response.body = app
            response
          else
            raise Fog::Compute::OracleCloud::NotFound.new("Security application #{name} does not exist");
          end
        end
      end
    end
  end
end
