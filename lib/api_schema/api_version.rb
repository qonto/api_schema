module ApiSchema
  class ApiVersion
    attr_accessor :configuration, :resources, :serializers, :imported_versions, :errors

    def initialize(configuration)
      @configuration = configuration
      @resources = []
      @serializers = []
      @imported_versions = []
      @errors = {}
    end


    def check_consistency
      check_serializers_consistency
      check_resources_consistency

      raise UndefinedSerializersError, error_message  unless errors.empty?
    end

    private

    def check_serializers_consistency
      serializers.each do |serializer|
        serializer.prior_references.each do |reference|
          add_errors(:undefined_reference, reference) unless find_or_import(reference.id)
        end
      end
    end

    def check_resources_consistency
      resources.each do |resource|
        add_errors(:undefined_body, resource) unless find_or_import(resource.body_param)
        add_errors(:undefined_response, resource) unless find_or_import(resource.resp.model)
      end
    end

    def find_or_import(serializer_id)
      return true unless serializer_id
      return true if find_in_version(self, serializer_id)
      return true if find_in_another_version(serializer_id)
    end

    def find_in_another_version(serializer_id)
      imported_versions.each do |import|
        version = imported_version(import)
        serializer = find_in_version(version, serializer_id)
        return serializers << serializer if serializer
      end

      false
    end

    def find_in_version(version, serializer_id)
      version.serializers.detect { |s| s.id == serializer_id }
    end

    def imported_version(import)
      "#{import.name.capitalize}::#{import.version.capitalize}::BaseDocs".constantize.api_version
    end

    def add_errors(key, object)
      errors[key] ||= []
      errors[key] << object
    end

    def error_message
      message = errors.reduce([]) do |memo, (key, errors)|
        case key
        when :undefined_body
          memo += errors.map(&self.method(:body_error))
        when :undefined_response
          memo += errors.map(&self.method(:response_error))
        when :undefined_reference
          memo += errors.map(&self.method(:reference_error))
        end
      end

      message.join(" \n")
    end

    def body_error(object)
      "There is no '#{object.body_param}' body parameter defined for #{object.base_path} resource. Please define it with 'request_body' method"
    end

    def response_error(object)
      "There is no '#{object.resp.model}' response defined for '#{object.summary}' resource. Please define it with 'serializer' method"
    end

    def reference_error(object)
      "Reference #{object.id} is not defined"
    end
  end
end
