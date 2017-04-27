module Swagger
  module Blocks
    module Nodes
      class OperationNode < Node
        def success_response(code, model_name = nil, fields = [])
          response code do
            schema do
              key :'$ref', model_name if model_name
              fields.each do |f|
                property f.name do
                  key :type, f.type
                end
              end
            end
          end
        end

        def header_param(name, type)
          parameter do
            key :name, name
            key :in, :header
            key :required, true
            key :type, type
          end
        end

        def body_param(model_name)
          parameter do
            key :name, model_name
            key :in, :body
            key :required, true
            schema do
              key :'$ref', model_name
            end
          end
        end

        def query_param(name, type)
          parameter do
            key :name, name
            key :in, :query
            key :required, true
            key :type, type
          end
        end

        def path_param(name, type)
          parameter do
            key :name, name
            key :in, :path
            key :required, true
            key :type, type
          end
        end

        def error_responses(model_name, descriptions, *codes)
          codes.each do |code|
            response code do
              key :description, descriptions[code]
              schema do
                key :'$ref', model_name
              end
            end
          end
        end
      end
    end
  end
end
