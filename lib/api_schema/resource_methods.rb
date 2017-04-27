module ApiSchema
  module ResourceMethods

    private

    def get(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:get, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      # build(resource, :get)
    end

    def post(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:post, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      # build(resource, :post)
    end

    def put(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:put, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      # build(resource, :put)
    end

    def patch(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:patch, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      # build(resource, :patch)
    end

    def delete(base_path = default_path, extra_path: nil, &block)
      resource = ResourceDefinition.new(:delete, base_path, extra_path)
      resource.instance_eval(&block)
      api_version.resources << resource
      # build(resource, :delete)
    end

    def default_path
      self.to_s.split("::").last.gsub("Controller", "").split(/(?=[A-Z])/).map(&:downcase).join('_')
    end
  end
end
