module ApiSchema
  class SerializerDefinition
    include ::Swagger::Blocks::ClassMethods

    @@serializers = {}

    PriorReference = ::Struct.new(:name, :type, :desc)

    attr_reader :name, :fields, :references, :parent
    attr_accessor :type, :title, :description

    def initialize(name, type, title=nil, parent_name = nil)
      @name = name
      @type = type
      @title = title || name
      @parent = @@serializers[parent_name]
      @fields = parent&.fields || []
      @prior_references = parent&.prior_references || []
      @references = []
      @@serializers[name] = self
    end

    def required_fields
      fields.select { |f| f.required? }.map(&:name) + references.map(&:name)
    end

    def reference(refernce_name, type: :object, desc: nil)
      @prior_references << PriorReference.new(refernce_name, type, desc)
    end

    def build
      build_references
      sd = self
      swagger_schema(name) { schema_for(sd) }
    end

    def build_references
      @prior_references.each do |pr|
        reference = @@serializers[pr.name].clone
        reference.type = pr.type
        reference.description = pr.desc
        reference.title = reference.title.to_s.pluralize if type == :array
        @references << reference
      end
    end

    def method_missing(type, *args, &block)
      options = args[1] || {}
      @fields << Field.new(type, args[0], options)
    end
  end
end
