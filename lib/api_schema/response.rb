module ApiSchema
  class Response

    attr_reader :code, :model, :fields

    def initialize(code, model)
      @code = code
      @model = model
      @fields = []
    end

    def method_missing(type, *args, &block)
      options = args[1] || {}
      @fields << Field.new(type, args[0], options)
    end
  end
end
