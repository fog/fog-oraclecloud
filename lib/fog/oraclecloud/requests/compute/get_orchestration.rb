module Fog
  module Compute
    class OracleCloud
      class Real
				def get_orchestration(name)
          if !name.start_with?("/Compute-") then
            # They haven't provided a well formed name, add their name in
            name = "/Compute-#{@identity_domain}/#{@username}/#{name}"
          end
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/orchestration#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def get_orchestration(name)
          response = Excon::Response.new
          clean_name = name.sub "/Compute-#{@identity_domain}/#{@username}/", ''

          if instance = self.data[:orchestrations][clean_name] 
            response.status = 200
            response.body = instance
            response
          else;
            raise Fog::Compute::OracleCloud::NotFound.new("Orchestration #{name} does not exist");
          end
        end
      end
    end
  end
end
