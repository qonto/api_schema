module ApiSchema
  class ResourceDefinition
    include ::Swagger::Blocks::ClassMethods

    def initialize(method, base_path, extra_path = nil)
      @base_path = base_path
      @extra_path = extra_path
      @method = method
      @header_params = []
      @path_params = []
      @query_params = []
    end

    HeaderParam = ::Struct.new(:name, :type)
    PathParam = ::Struct.new(:name, :type)
    QueryParam = ::Struct.new(:name, :type)

    attr_reader :method, :summary, :description, :header_params, :body_param,
    :path_params, :query_params, :resp,
    :errors, :base_path, :extra_path, :full_path

    def name(name)
      @summary = name
    end

    def desc(desc)
      @description = desc
    end

    def header(name, type)
      @header_params << HeaderParam.new(name, type)
    end

    def body(body_param)
      @body_param = body_param
    end

    def path_param(name, type)
      @path_params << PathParam.new(name, type)
    end

    def query_param(name, type)
      @query_params << QueryParam.new(name, type)
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

    def build
      error_model = :error_model
      error_desc = {
        '401' => "Unauthorized",
        '403' => "Forbidden",
        '404' => "Not found",
        '422' => "Unprocessable Entity"
     }
      resource = self
      resource.generate_full_path

      swagger_path resource.full_path do
        operation(resource.method) do
          key :summary, resource.summary
          key :description, resource.description
          key :operationId, "#{resource.method}_#{resource.full_path}"
          key :tags, resource.base_path
          security do
            key :authorization, []
          end
          body_param(resource.body_param) if resource.with_body?

          resource.header_params.each do |p|
            header_param(p.name, p.type)
          end
          resource.path_params.each do |p|
            path_param(p.name, p.type)
          end
          resource.query_params.each do |p|
            query_param(p.name, p.type)
          end

          success_response(resource.resp.code, resource.resp.model, resource.resp.fields)
          error_responses(error_model, error_desc, *resource.errors) if resource.with_errors?
        end
      end
    end
  end
end
