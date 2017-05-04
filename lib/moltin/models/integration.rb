module Moltin
  module Models
    class Integration < Models::Base
      attributes :type, :id, :integration_type, :enabled, :name, :description,
                 :observes, :configuration

      def logs
        client.integrations.logs_for(id)
      end

      def jobs
        client.integrations.jobs_for(id)
      end
    end
  end
end
