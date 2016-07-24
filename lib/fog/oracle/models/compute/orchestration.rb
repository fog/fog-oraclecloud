require 'fog/core/model'

module Fog
  module Compute
  	class Oracle
	    class Orchestration < Fog::Model
	      identity  :uri

	      attribute :account
	      attribute :description
	      attribute :info
	      attribute :oplans
	     	attribute :relationships
	      attribute :schedule
	      attribute :status
	      attribute :status_timestamp
	      attribute :user
	      attribute :name

 				def save
          identity ? update : create
        end

        def create
        	requires :name, :oplans
          data = service.create_orchestration(name, oplans, 
									          	:schedule => schedule,
									          	:account => account,
									          	:description => description,
									          	:relationships => relationships)
          merge_attributes(data.body)
        end

        def update
        	requires :name, :oplans
          data = service.update_orchestration(name, oplans, 
									          	:schedule => schedule,
									          	:account => account,
									          	:description => description,
									          	:relationships => relationships)
          merge_attributes(data.body)
        end

        def destroy
        	requires :name
        	service.delete_orchestration(name)
        end
	    end
	  end
  end
end
