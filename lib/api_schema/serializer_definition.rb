module ApiSchema
  class SerializerDefinition
    include ::Swagger::Blocks::ClassMethods

    PriorReference = ::Struct.new(:id, :type, :desc)

    attr_reader :id, :fields, :references, :parent, :api_version
    attr_accessor :type, :name, :description, :prior_references

    def initialize(id, type, api_version, name=nil, parent_id = nil)
      @id = id
      @type = type
      @name = name || id
      @api_version = api_version
      @parent = api_version.serializers.detect { |s| s.id == parent_id } if parent_id
      @fields = parent&.fields || []
      @prior_references = parent&.prior_references || []
      @references = []
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
        reference = api_version.serializers.detect { |s| s.id == pr.id }
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
