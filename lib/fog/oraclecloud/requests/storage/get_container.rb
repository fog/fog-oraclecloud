module Fog
  module Storage
    class OracleCloud
      class Real
      	def get_container(name)
          response = request(
            :expects  => [204],
            :method   => 'HEAD',
            :path     => "/v1/Storage-#{@identity_domain}/#{name}"
          )
          response
        end
        def get_container_with_objects(name)
          response = request(
            :expects  => [204,200],
            :method   => 'GET',
            :path     => "/v1/Storage-#{@identity_domain}/#{name}?format=json"
          )
          response
        end
      end

      class Mock
        def get_container(name)
          response = Excon::Response.new

          if container = self.data[:containers][name] 
            response.status = 200
            response.body = container
            response
          else;
            raise Excon::Error::NotFound.new("Storage Container #{name} does not exist");
          end
        end

        def get_container_with_objects(name)
          response = Excon::Response.new

          if container = self.data[:containers][name] 
            response.status = 200
            response.body = [{
              "hash": "aea0077f346227c91cd68e955721e262",
              "last_modified": "2016-07-30T03:39:24.477480",
              "bytes": 513,
              "name": "Ausemon/1df0886e-3133-498f-9472-79632485b311/logs/web.1/36322757-7666-429a-87cc-3c320caf8afa/server.out.zip",
              "content_type": "application/zip"
            },
            {
              "hash": "2c35a8adaf8e7a3375e1354264135f94",
              "last_modified": "2016-07-30T12:51:26.124600",
              "bytes": 6524,
              "name": "Ausemon/1df0886e-3133-498f-9472-79632485b311/logs/web.1/6ad56533-791f-4a79-8e5d-bbef854a2b50/server.out.zip",
              "content_type": "application/zip"
            }]
            response
          else;
            raise Fog::Compute::OracleCloud::NotFound.new("Storage Container #{name} does not exist");
          end 
        end
      end
    end
  end
end
