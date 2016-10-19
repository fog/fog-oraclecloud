require 'securerandom'

module Fog
  module Storage
    class OracleCloud
      class Real

      	def create_container(name)
          request({
            :method   => 'PUT',
            :expects  => [201,202],
            :path     => "/v1/Storage-#{@identity_domain}/#{name}"
          }, false)
        end

      end

      class Mock
      	def create_container (name)
          response = Excon::Response.new

          self.data[:containers][name] = {
            'name' => name,
            'count' => 0,
            'bytes' => 0
          }
          response.status = 201
          response.headers = {
            'Content-Length' => 0,
            'X-Container-Bytes-Used' => 0,
            'X-Container-Object-Count' => 0,
            'Date'=>Time.now.strftime('%Y-%m-%dT%H:%M:%S'),
            'X-Timestamp'=>Time.now.to_i,
            'X-Trans-id'=>SecureRandom.uuid
          }
          response
        end
      end
    end
  end
end
