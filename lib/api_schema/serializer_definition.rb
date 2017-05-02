module ApiSchema
  class SerializerDefinition
    include ::Swagger::Blocks::ClassMethods

    @@serializers = {}

    PriorReference = ::Struct.new(:id, :type, :desc)

    attr_reader :id, :fields, :references, :parent
    attr_accessor :type, :name, :description

    def initialize(id, type, name=nil, parent_id = nil)
      @id = id
      @type = type
      @name = name || id
      @parent = @@serializers[parent_id]
      @fields = parent&.fields || []
      @prior_references = parent&.prior_references || []
      @references = []
      @@serializers[id] = self
    end

    def required_fields
      fields.select { |f| f.required? }.map(&:name) + references.map(&:name)
    end

    def reference(refernce_id, type: :object, desc: nil)
      @prior_references << PriorReference.new(refernce_id, type, desc)
    end

    def build
      build_references
      sd = self
      swagger_schema(id) { schema_for(sd) }
    end

    def build_references
      @prior_references.each do |pr|
        reference = @@serializers[pr.id].clone
        reference.type = pr.type
        reference.description = pr.desc
        reference.name = reference.name.to_s.pluralize if reference.type == :array
        @references << reference
      end
    end

    def method_missing(type, *args, &block)
      options = args[1] || {}
      @fields << Field.new(type, args[0], options)
    end
  end
end
