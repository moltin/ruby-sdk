module Moltin
  module Resources
    class Integrations < Resources::Base
      def logs
        response(call(:get, "#{uri}/logs"))
      end

      def job_logs_for(integration_id, job_id)
        response(call(:get, "#{uri}/#{integration_id}/jobs/#{job_id}/logs"))
      end

      def jobs_for(id)
        response(call(:get, "#{uri}/#{id}/jobs"))
      end

      def logs_for(id)
        response(call(:get, "#{uri}/#{id}/logs"))
      end

      private

      # Private: Gives the type of the current Resources class.
      def type
        'integration'
      end

      # Private: Gives the model class to use to instantiate the responses data.
      def model_name
        Moltin::Models::Integration
      end

      # Private: Gives the URI to call for the current Resources class.
      def uri
        "#{@config.version}/integrations"
      end
    end
  end
end
