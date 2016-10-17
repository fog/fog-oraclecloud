require 'fog/compute/models/server'

module Fog
  module OracleCloud
    class Java
      class Database < Fog::Model
      	identity :service_name

      	attribute :infra
      	attribute :connect_string
      	attribute :version
      	attribute :pdb
      
      end
    end
  end
end
