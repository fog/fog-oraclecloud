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

	      def running?
	      	status == 'running'
	      end

	      def ready?
	      	status == 'ready'
	      end

	      def stopped?
	      	status == 'stopped'
	      end

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

        def reload
		      requires :name

		      data = begin
		        collection.get(name)
		      rescue Excon::Errors::SocketError
		        nil
		      end

		      return unless data

		      new_attributes = data.attributes
		      merge_attributes(new_attributes)
		      self
		    end

        def destroy
        	requires :name
        	service.delete_orchestration(name)
        end

        def start
        	requires :name
        	service.start_orchestration(name)
        end

        def stop
        	requires :name
        	service.stop_orchestration(name)
        end
	    end
	  end
  end
end
