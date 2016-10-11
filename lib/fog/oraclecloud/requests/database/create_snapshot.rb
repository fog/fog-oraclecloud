module Fog
  module OracleCloud
    class Database
      class Real

      	def create_snapshot(name, description, database_id)
          body_data     = {
            'name'              => name,
            'description'       => description
          }
          body_data = body_data.reject {|key, value| value.nil?}
        
          response = request(
            :method   => 'POST',
            :expects  => 202,
            :path     => "/paas/api/v1.1/instancemgmt/#{@identity_domain}/services/dbaas/instances/#{database_id}/snapshots",
            :body     => Fog::JSON.encode(body_data),
          )
          # Store the database reference in the model, so that we can use it later
          response.database_id = service_name
          response
        end
      end

      class Mock
        def create_snapshot(name, description, database_id)
      		response = Excon::Response.new

          data = {
            'name' => name,
            'description' => description,
            'creationTime' => Time.now,
            'clonedServicesSize' => 1,
            'status'=>'In Progress',
            'database_id'=>database_id,
            'clonedServices'=>[{
              'clonedServiceName'=>'ClonedService1',
              'clonedServiceCreationTime'=> Time.now
              }]
          }
          if !self.data[:snapshots].key?(database_id) then self.data[:snapshots][database_id] = {} end
          self.data[:snapshots][database_id][name] = data
          self.data[:created_at][name] = Time.now
          response.status = 202
          response
      	end
      end
    end
  end
end
