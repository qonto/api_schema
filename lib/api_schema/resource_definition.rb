module ApiSchema
  class ResourceDefinition
    include ::Swagger::Blocks::ClassMethods

    @neighbors = {}

    def initialize(method, base_path, extra_path = nil)
      @base_path = base_path
      @extra_path = extra_path
      @method = method
      @header_params = []
      @path_params = []
      @query_params = []
    end

    HeaderParam = ::Struct.new(:name, :type, :required)
    PathParam = ::Struct.new(:name, :type, :required)
    QueryParam = ::Struct.new(:name, :type, :required)

    attr_reader :method, :summary, :description, :header_params, :body_param,
    :path_params, :query_params, :resp,
    :errors, :base_path, :extra_path, :full_path

    def self.neighbors
      @neighbors
    end

    def name(name)
      @summary = name
    end

    def desc(desc)
      @description = desc
    end

    def header(name, type, required: true)
      @header_params << HeaderParam.new(name, type, required)
    end

    def body(body_param)
      @body_param = body_param
    end

    def path_param(name, type, required: true)
      @path_params << PathParam.new(name, type, required)
    end

    def query_param(name, type, required: true)
      @query_params << QueryParam.new(name, type, required)
    end

    def response(code, model_name = nil, &block)
      @resp = Response.new(code, model_name)
      if block && model_name.nil?
        block.call(@resp)
      end
    end

    def error!(*codes)
      @errors = *codes
    end

    def with_path_param?
      !path_params.empty?
    end

    def with_body?
      !!body_param
    end

    def with_errors?
      !errors.empty?
    end

    def generate_full_path
      @full_path = with_path_param? ? "/#{base_path}/{id}" : "/#{base_path}"
      @full_path << "/#{extra_path}" if extra_path
    end

    def build_neighbors
      generate_full_path
      self.class.neighbors[full_path] ||= []
      self.class.neighbors[full_path] << self
    end

    def build
      error_model = :error_model
      error_desc = {
        '401' => "Unauthorized",
        '403' => "Forbidden",
        '404' => "Not found",
        '422' => "Unprocessable Entity"
     }
      resource = self
      resource_class = self.class
      swagger_path resource.full_path do
        resource_class.neighbors[resource.full_path].each do |r|
          operation(r.method) do
            key :summary, r.summary
            key :description, r.description
            key :operationId, "#{r.method}_#{r.full_path}"
            key :tags, r.base_path
            security do
              key :authorization, []
            end
            body_param(r.body_param) if r.with_body?

            r.header_params.each do |p|
              header_param(p.name, p.type, p.required)
            end
            r.path_params.each do |p|
              path_param(p.name, p.type, p.required)
            end
            r.query_params.each do |p|
              query_param(p.name, p.type, p.required)
            end

            success_response(r.resp.code, r.resp.model, r.resp.fields)
            error_responses(error_model, error_desc, *r.errors) if r.with_errors?
          end
        end
      end
    end
  end
end
