module ActiveJob
  module QueueAdapters
    class LambAdapter
      def enqueue(job)
        client = Aws::Lambda::Client.new(region: 'us-east-1')

        response = client.invoke(function_name: 'lamb',
                                 invocation_type: 'Event',
                                 payload: JSON[job.serialize])

        puts response
      end
    end
  end
end
