module ApiSchema
  module RootMethods

    def inherited(subclass)
      instance_var = "@api_version"
      subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
      instance_var_neighbors = "@version_resources"
      subclass.instance_variable_set(instance_var_neighbors, instance_variable_get(instance_var_neighbors))
    end

    def configure
      configuration = Configuration.new
      yield(configuration)
      @api_version = ApiVersion.new(configuration)
      @version_resources = {}
      @version_serializers = {}
    end

    def import_serializers_from(name, api_version)
      @api_version.imported_versions << OpenStruct.new(name: name,
                                                       api_version: api_version)
    end

    def api_version
      @api_version
    end

    def version_resources
      @version_resources
    end

    def version_serializers
      @version_serializers
    end

    def generate_json
      @api_version.configuration.build
      @api_version.check_consistency
      @api_version.serializers.each { |s| s.build }
      @api_version.resources.each { |r| r.build(version_resources) }

      nodes = [@api_version.configuration] +  @api_version.serializers + @api_version.resources
      ::Swagger::Blocks.build_root_json(nodes)
    end
  end
end
