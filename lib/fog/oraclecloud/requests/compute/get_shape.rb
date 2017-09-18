module Fog
  module Compute
    class OracleCloud
      class Real
				def get_shape(name)
 					response = request(
            :expects  => 200,
            :method   => 'GET',
            :path     => "/shape/#{name}",
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json',
              'Accept' => 'application/oracle-compute-v3+json'
            }
          )
          response
        end
      end

      class Mock
        def get_shape(name)
          response = Excon::Response.new

          if shape = self.data[:shapes][name] 
            response.status = 200
            response.body = shape
            response
          else;
            raise Fog::Compute::OracleCloud::NotFound.new("Shape #{name} does not exist");
          end
        end
      end
    end
  end
end
