module Fog
  module Compute
    class OracleCloud
      class Real
      	def create_orchestration (name, oplans, options={})

          # Clean up names in case they haven't provided the fully resolved names
          name.sub! "/Compute-#{@identity_domain}/#{@username}/", ''
          oplans.map do |oplan|
            oplan['objects'].map do |object|
              if oplan['obj_type'] == 'launchplan' then
                object['instances'].map do |instance|
                  if !instance['name'].start_with?("/Compute-") then
                    instance['name'] = "/Compute-#{@identity_domain}/#{@username}/#{instance['name']}"
                  end
                end
              else
                if !object['name'].start_with?("/Compute-") then
                  object['name'] = "/Compute-#{@identity_domain}/#{@username}/#{object['name']}"
                end
              end
            end
          end
          body_data     = {
            'name' 		      => "/Compute-#{@identity_domain}/#{@username}/#{name}",
            'oplans'        => oplans,
            'relationships' => options[:relationships],
            'description'   => options[:description],
            'account'       => options[:account],
            'schedule'      => options[:schedule]
          }
          body_data = body_data.reject {|key, value| value.nil?}
          request(
            :method   => 'POST',
            :expects  => 201,
            :path     => "/orchestration/",
            :body     => Fog::JSON.encode(body_data),
            :headers  => {
              'Content-Type' => 'application/oracle-compute-v3+json'
            }
          )
      	end
      end
    end
  end
end
