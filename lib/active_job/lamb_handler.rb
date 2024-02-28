module ActiveJob
  class LambHandler
    def self.handle(event:, context:)
      Base.execute event
    end
  end
end
