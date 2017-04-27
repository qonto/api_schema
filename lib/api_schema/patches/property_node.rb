module Swagger
  module Blocks
    module Nodes
      class PropertyNode < Node
        def requires(fields)
          key :required, fields
        end

        def property_schema_for(serializer)
          property serializer.title do
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
