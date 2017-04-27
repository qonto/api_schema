module ApiSchema
  module SerializerMethods

    private

    def serializer(name, structure: :object, title: nil, parent: nil)
      serializer = SerializerDefinition.new(name, structure, title, parent)
      yield serializer if block_given?
      api_version.serializers << serializer
    end

    def array_serializer(name, title: nil, parent: nil)
      serializer = SerializerDefinition.new(name, :array, title, parent)
      yield serializer if block_given?
      api_version.serializers << serializer
    end

    alias_method :request_body, :serializer
  end
end
