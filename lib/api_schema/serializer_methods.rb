module ApiSchema
  module SerializerMethods

    private

    def serializer(id, structure: :object, name: nil, parent: nil)
      serializer = SerializerDefinition.new(id, structure, version_serializers, name, parent)
      yield serializer if block_given?
      api_version.serializers << serializer
    end

    def array_serializer(id, name: nil, parent: nil)
      serializer = SerializerDefinition.new(id, :array, version_serializers, name, parent)
      yield serializer if block_given?
      api_version.serializers << serializer
    end

    alias_method :request_body, :serializer
  end
end
