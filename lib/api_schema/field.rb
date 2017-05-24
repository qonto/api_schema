module ApiSchema
  class Field

    attr_accessor :type, :name, :format, :required, :description, :allowed_values

    def initialize(type, name, options = {})
      @type = type
      @name = name
      @format = options.fetch(:format, nil)
      @required = options.fetch(:required, false)
      @description = options.fetch(:desc, '')
      @allowed_values = [*options.fetch(:allowed_values, nil)]
    end

    def required?
      required
    end
  end
end
