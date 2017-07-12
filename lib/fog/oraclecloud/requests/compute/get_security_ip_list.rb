module Fog
  module Compute
    class OracleCloud
      class Real
				def get_security_ip_list(name)
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''

 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/seciplist/Compute-#{@identity_domain}/#{@username}/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def get_security_ip_list(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''

          if instance = self.data[:security_ip_lists][clean_name] 
            response.status = 200
            response.body = instance
            response
          else
            raise Fog::Compute::OracleCloud::NotFound.new("Security IP List #{name} does not exist");
          end
        end
      end
    end
  end
end
