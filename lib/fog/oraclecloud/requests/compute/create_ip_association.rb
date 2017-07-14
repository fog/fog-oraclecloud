module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_ip_association (params)
          params = params.reject {|key, value| value.nil?}
          puts Fog::JSON.encode(params)
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/ip/association/",
            :body     => Fog::JSON.encode(params),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end

      class Mock
        def create_ip_association (params)
          response = Excon::Response.new
          name = SecureRandom.uuid

          self.data[:ip_associations][name] = {
            'name' => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'account' => "/Compute-#{@identity_domain}/#{@username}",
            'uri' => "#{@api_endpoint}ip/reservation/Compute-#{@identity_domain}/#{@username}/#{name}",
            'parentpool' => params[:parentpool],
            'vcable' => params[:vcable]
          }
          instance = self.data[:instances].detect { |i|i[1]['vcable_id'] = params[:vcable]}
          if instance.nil? then
            # TODO: Add error handling. And don't create ip association
          else
            # Update it's networking
            instance[1]['networking']['eth0']['nat']="#{params[:parentpool]}"
          end
          response.status = 201
          response.body = self.data[:ip_associations][name]
          response
        end
      end
    end
  end
end