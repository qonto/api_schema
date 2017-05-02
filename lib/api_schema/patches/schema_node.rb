module Swagger
  module Blocks
    module Nodes
      class SchemaNode < Node
        def requires(fields)
          key :required, fields
        end

        def schema_for(serializer)
          key :title, serializer.id.to_s.humanize
          serializer.type == :array ? array_schema(serializer) : single_schema(serializer)
        end

        def single_schema(serializer)
          key :required, serializer.name
          property serializer.name do
            key :type, :object
            requires serializer.required_fields
            serializer.fields.each do |f|
              property f.name do
                key :type, f.type
                key :format, f.format if f.format
                key :description, f.description
              end
            end
            serializer.references.each do |r|
              property_schema_for(r) #schema_for from PropertyNode class
            end
          end
        end

        def array_schema(serializer)
          requires serializer.required_fields
          serializer.fields.each do |f|
            property f.name do
              key :type, f.type
              key :format, f.format if f.format
              key :description, f.description
            end
          end
          serializer.references.each do |r|
            property_schema_for(r)
          end
        end

        def property_schema_for(serializer)
          property serializer.name do
            key :type, serializer.type
            key :description, serializer.description
            requires serializer.required_fields
            serializer.fields.each do |f|
              property f.name do
                key :type, f.type
                key :format, f.format if f.format
                key :description, f.description
              end
            end
            serializer.references.each do |r|
              property_schema_for(r)
            end
          end
        end
      end
    end
  end
end
