module ApiSchema
  module SerializerMethods

    private

    def serializer(id, structure: :object, name: nil, parent: nil)
      serializer = SerializerDefinition.new(id, structure, api_version, name, parent)
      yield serializer if block_given?
      api_version.serializers << serializer
    end

    def array_serializer(id, name: nil, parent: nil)
      serializer = SerializerDefinition.new(id, :array, api_version, name, parent)
      yield serializer if block_given?
      api_version.serializers << serializer
    end

    alias_method :request_body, :serializer
  end
end
