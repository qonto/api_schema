module ApiSchema
  module RootMethods
    def configure
      configuration ||= Configuration.new
      yield(configuration)
      @@api_version = ApiVersion.new(configuration)
    end

    def api_version
      @@api_version
    end

    def generate_json
      @@api_version.configuration.build
      @@api_version.serializers.each { |s| s.build }
      @@api_version.resources.each { |r| r.build }

      nodes = [@@api_version.configuration] +  @@api_version.serializers + @@api_version.resources
      ::Swagger::Blocks.build_root_json(nodes)
    end
  end
end
