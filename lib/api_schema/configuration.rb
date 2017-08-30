module ApiSchema
  class Configuration
    include ::Swagger::Blocks::ClassMethods

    attr_accessor :title, :description, :version, :host,
    :base_path, :terms_of_service, :contact_name,
    :consumes, :produces, :authorization,
    :error_model, :error_desc

    attr_reader :descriptions_path

    def initialize
      @error_model = 'error_model'
      @consumes = 'application/json'
      @produces = 'application/json'
    end

    def descriptions_path=(descriptions_path)
      @descriptions_path = "#{Dir.pwd}/#{descriptions_path}"
    end

    def build
      configuration = self
      swagger_root do
        key :swagger, '2.0'
        info do
          key :version, configuration.version
          key :title, configuration.title
          key :description, configuration.description
          key :termsOfService, configuration.terms_of_service
          contact do
            key :name, configuration.contact_name
          end
        end
        security_definition :authorization do
          key :name, :Authorization
          key :type, :apiKey
          key :in, :header
        end if configuration.authorization
        key :host, configuration.host
        key :basePath, configuration.base_path
        key :consumes, configuration.consumes
        key :produces, configuration.produces
      end
    end
  end
end
