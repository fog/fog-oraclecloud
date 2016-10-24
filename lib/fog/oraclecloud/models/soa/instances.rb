require 'fog/core/collection'

module Fog
  module OracleCloud
    class SOA
      class Instances < Fog::Collection

      	model Fog::OracleCloud::SOA::Instance

      	def all
          data = service.list_instances().body['services']
          load(data)
        end

        def get(id)
          new(service.get_instance(id).body) 
        end

        def create(attributes = {}, db_attributes = {})
          if attributes[:db_service_name].nil?
            # Attempt to create a database instance for them
            db_name = db_attributes[:service_name] || "#{attributes[:service_name]}-DB"
            db_attributes.merge!({
              :service_name => "#{attributes[:service_name]}-DB",
              :edition => 'EE',
              :ssh_key => attributes[:ssh_key],
              :shape => 'oc3',
              :version => '12.1.0.2',
              :admin_password => attributes[:admin_password],
              :backup_destination => 'BOTH'
            }) { |key, v1, v2| v1 }
            # Check it doesn't exist already
            begin
              db = Fog::OracleCloud[:database].instances.get(db_name)
            rescue Fog::OracleCloud::Database::NotFound => error
              # Doesn't exist, create it first
              db = Fog::OracleCloud[:database].instances.create(db_attributes)
              db.wait_for { ready? }
            end
            attributes.merge!({
              :dba_name => 'SYS',
              :dba_password => db_attributes[:admin_password],
              :db_service_name => db_name
            })
          end
          # Now provision SOA
          object = new(attributes)
          object.save
          object
        end
      end
    end
  end
end
