module ApiSchema
  module ResourceMethods

    private

    def get(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:get, api_version, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      resource.build_neighbors(version_resources)
    end

    def post(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:post, api_version, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      resource.build_neighbors(version_resources)
    end

    def put(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:put, api_version, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      resource.build_neighbors(version_resources)
    end

    def patch(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:patch, api_version, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      resource.build_neighbors(version_resources)
    end

    def delete(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:delete, api_version, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      resource.build_neighbors(version_resources)
    end

    def default_path
      self.to_s.split("::").last.gsub("Controller", "").split(/(?=[A-Z])/).map(&:downcase).join('_')
    end
  end
end
