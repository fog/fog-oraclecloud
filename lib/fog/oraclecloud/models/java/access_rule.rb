module Fog
  module OracleCloud
    class Java
      class AccessRule < Fog::Model
      	identity :rule_name,       :aliases=>'ruleName'

      	attribute :description
      	attribute :status
      	attribute :source
        attribute :destination
        attribute :ports
        attribute :protocol
        attribute :rule_type,       :aliases=>'ruleType'

        attribute :service_name
      
        def save
          #identity ? update : create
          create
        end

        def create
          requires :description, :destination, :ports, :rule_name, :source, :status, :service_name

          params = {
            :ruleName => rule_name,
            :description => description,
            :ports => ports,
            :status => status,
            :destination => destination,
            :protocol => protocol,
            :ruleType => 'USER',
            :source => source
          }
          service.create_access_rule(service_name, params)

          Fog.wait_for { self.reload rescue nil } unless Fog.mock?
        end

        def destroy
          requires :rule_name, :service_name
          data = service.delete_access_rule(service_name, rule_name).body
          merge_attributes(data)

          Fog.wait_for { self.reload rescue nil } unless Fog.mock?

        end

        def enable
          requires :rule_name, :service_name
          data = service.enable_access_rule(service_name, rule_name).body
          merge_attributes(data)
        end

        def disable
          requires :rule_name, :service_name
          data = service.disable_access_rule(service_name, rule_name).body
          merge_attributes(data)
        end
      end
    end
  end
end
