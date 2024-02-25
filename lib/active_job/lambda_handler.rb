module ActiveJob
  class LambdaHandler
    def self.handle(event:, context:)
      Base.execute event
    end
  end
end
