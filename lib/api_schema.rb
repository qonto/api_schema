require 'active_support/inflector'
require 'swagger/blocks'

require 'api_schema/patches/operation_node'
require 'api_schema/patches/property_node'
require 'api_schema/patches/schema_node'

require "api_schema/configuration"
require "api_schema/api_version"
require "api_schema/root_methods"
require "api_schema/root_config"
require "api_schema/field"
require "api_schema/response"
require "api_schema/serializer_definition"
require "api_schema/serializer_methods"
require "api_schema/resource_definition"
require "api_schema/resource_methods"
require "api_schema/version"

module ApiSchema

  def self.included(base)
    base.extend(RootMethods)
    base.extend(SerializerMethods)
    base.extend(ResourceMethods)
  end
end
