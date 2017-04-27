module ApiSchema
  class Field

    attr_accessor :type, :name, :format, :required, :description

    def initialize(type, name, options = {})
      @type = type
      @name = name
      @format = options.fetch(:format, nil)
      @required = options.fetch(:required, false)
      @description = options.fetch(:desc, '')
    end

    def required?
      required
    end
  end
end
