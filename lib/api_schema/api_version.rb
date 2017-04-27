module ApiSchema
  class ApiVersion
    attr_accessor :configuration, :resources, :serializers

    def initialize(configuration)
      @configuration = configuration
      @resources = []
      @serializers = []
    end
  end
end
