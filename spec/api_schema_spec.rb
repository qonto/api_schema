require "spec_helper"

module First
  module V1
    class BaseDocs
      include ApiSchema

      configure do |config|
        config.title = 'Users API'
        config.description = 'API for users'
        config.version = '1.0'
        config.host = 'sample.com'
        config.base_path = '/api'
        config.terms_of_service = 'https://sample.com/terms'
        config.contact_name = 'API Team'
        config.consumes = 'application/json'
        config.produces = 'application/json'
        config.authorization = true
        config.error_model = :error_model
        config.error_desc = {
          '401' => "Unauthorized",
          '403' => "Forbidden",
          '404' => "Not found",
          '422' => "Unprocessable Entity"
        }
      end

      serializer :file do |f|
        f.string :file_name, required: true
        f.string :file_size, required: true
        f.string :file_content_type, required: true
        f.string :file_url, required: true
      end
    end

    class ErrorSerializer < BaseDocs
      serializer :error_model do |f|
        f.integer :code, required: true
        f.string  :message, required: true
      end
    end

    class AttachmentSerializer < BaseDocs

      serializer :attachment do |f|
        f.string    :id, required: true
        f.string    :download_url, required: true, allowed_values: ['Slug1', 'Slug2']
        f.string    :slug, required: true, desc: "String representing the human id, composed by subject slug, model name, sequential id. (i.e 'milton-arps-zabel-3311-transaction-27-new-attachment-1')"
        f.string    :organization_id, required: true
        f.string    :subject_id
        f.string    :subject_type, allowed_values: 'Company'
        f.string    :created_at, required: true
        f.referece  :file
      end

    end

    class AttachmentsController < BaseDocs

      get do
        path_param :id, :string
        name 'Get attachment'
        desc 'Get an attachment'
        response 200, :attachment
        error! 401, 403, 404, 422
      end

      get extra_path: :download do
        path_param :id, :string
        name 'Download attachment'
        desc 'Download an attachment'
        response 200, :file
        error! 401, 403, 404, 422
      end

      post do
        body :create_attachment
        name 'Creates attachment'
        desc 'Creates a new attachment'
        response 200, :attachment
        error! 401, 403, 422
      end

      delete do
        path_param :id, :string
        name 'Delete attachment'
        desc 'Delete an attachment'
        response 200
        error! 401, 403, 404, 422
      end

      request_body :create_attachment, name: 'attachment' do |f|
        f.string :organization_id, required: true
        f.string :subject_id
        f.string :subject_type
      end
    end
  end
end

module First
  module V2
    class BaseDocs
      include ApiSchema

      configure do |config|
        config.title = 'Users API'
        config.description = 'API for users'
        config.version = '1.0'
        config.host = 'sample.com'
        config.base_path = '/api'
        config.terms_of_service = 'https://sample.com/terms'
        config.contact_name = 'API Team'
        config.consumes = 'application/json'
        config.produces = 'application/json'
        config.authorization = true
        config.error_model = :error_model
        config.error_desc = {
          '401' => "Unauthorized",
          '403' => "Forbidden",
          '404' => "Not found",
          '422' => "Unprocessable Entity"
        }
      end

      import_serializers_from :first, :v1

      serializer :file do |f|
        f.string :file_name, required: true
        f.string :file_size, required: true
        f.string :file_content_type, required: true
        f.string :file_url, required: true
      end
    end

    class ErrorSerializer < BaseDocs
      serializer :error_model do |f|
        f.integer :code, required: true
        f.string  :message, required: true
      end
    end

    class AttachmentsController < BaseDocs

      get do
        path_param :id, :string
        name 'Get attachment'
        desc 'Get an attachment'
        response 200, :attachment
        error! 401, 403, 404, 422
      end

      post do
        body :create_attachment
        name 'Creates attachment'
        desc 'Creates a new attachment'
        response 200, :attachment
        error! 401, 403, 422
      end
    end
  end
end

module Second
  class BaseDocs
    include ApiSchema

    configure do |config|
      config.title = 'Users API'
      config.description = 'API for users'
      config.version = '1.0'
      config.host = 'sample.com'
      config.base_path = '/api'
      config.terms_of_service = 'https://sample.com/terms'
      config.contact_name = 'API Team'
      config.consumes = 'application/json'
      config.produces = 'application/json'
      config.authorization = true
      config.error_model = :error_model
      config.error_desc = {
        '401' => "Unauthorized",
        '403' => "Forbidden",
        '404' => "Not found",
        '422' => "Unprocessable Entity"
      }
    end

    serializer :file do |f|
      f.string :file_name, required: true
      f.string :file_size, required: true
      f.string :file_content_type, required: true
      f.string :file_url, required: true
    end
  end

  class ErrorSerializer < BaseDocs
    serializer :error_model do |f|
      f.integer :code, required: true
      f.string  :message, required: true
    end
  end
end

module WrongResource
  class BaseDocs
    include ApiSchema

    configure do |config|
      config.title = 'Users API'
      config.description = 'API for users'
      config.version = '1.0'
      config.host = 'sample.com'
      config.base_path = '/api'
      config.terms_of_service = 'https://sample.com/terms'
      config.contact_name = 'API Team'
      config.consumes = 'application/json'
      config.produces = 'application/json'
      config.authorization = true
      config.error_model = :error_model
      config.error_desc = {
        '401' => "Unauthorized",
        '403' => "Forbidden",
        '404' => "Not found",
        '422' => "Unprocessable Entity"
      }
    end

    serializer :file do |f|
      f.string :file_name, required: true
      f.string :file_size, required: true
      f.string :file_content_type, required: true
      f.string :file_url, required: true
    end
  end

  class ErrorSerializer < BaseDocs
    serializer :error_model do |f|
      f.integer :code, required: true
      f.string  :message, required: true
    end
  end

  class AttachmentsController < BaseDocs

    get do
      path_param :id, :string
      name 'Get attachment'
      desc 'Get an attachment'
      response 200, :attachment
      error! 401, 403, 404, 422
    end

    post do
      body :create_attachment
      name 'Creates attachment'
      desc 'Creates a new attachment'
      response 200, :attachment
      error! 401, 403, 422
    end
  end
end

module WrongReference
  class BaseDocs
    include ApiSchema

    configure do |config|
      config.title = 'Users API'
      config.description = 'API for users'
      config.version = '1.0'
      config.host = 'sample.com'
      config.base_path = '/api'
      config.terms_of_service = 'https://sample.com/terms'
      config.contact_name = 'API Team'
      config.consumes = 'application/json'
      config.produces = 'application/json'
      config.authorization = true
      config.error_model = :error_model
      config.error_desc = {
        '401' => "Unauthorized",
        '403' => "Forbidden",
        '404' => "Not found",
        '422' => "Unprocessable Entity"
      }
    end

    serializer :file do |f|
      f.string :file_name, required: true
      f.string :file_size, required: true
      f.string :file_content_type, required: true
      f.string :file_url, required: true
      f.reference :attachment, type: :array
    end
  end

  class ErrorSerializer < BaseDocs
    serializer :error_model do |f|
      f.integer :code, required: true
      f.string  :message, required: true
    end
  end
end

module ImportReference
  class BaseDocs
    include ApiSchema

    configure do |config|
      config.title = 'Users API'
      config.description = 'API for users'
      config.version = '1.0'
      config.host = 'sample.com'
      config.base_path = '/api'
      config.terms_of_service = 'https://sample.com/terms'
      config.contact_name = 'API Team'
      config.consumes = 'application/json'
      config.produces = 'application/json'
      config.authorization = true
      config.error_model = :error_model
      config.error_desc = {
        '401' => "Unauthorized",
        '403' => "Forbidden",
        '404' => "Not found",
        '422' => "Unprocessable Entity"
      }
    end

    import_serializers_from :first, :v1

    serializer :file do |f|
      f.string :file_name, required: true
      f.string :file_size, required: true
      f.string :file_content_type, required: true
      f.string :file_url, required: true
      f.reference :attachment, type: :array
    end
  end

  class ErrorSerializer < BaseDocs
    serializer :error_model do |f|
      f.integer :code, required: true
      f.string  :message, required: true
    end
  end
end


describe ApiSchema do
  it "has a version number" do
    expect(ApiSchema::VERSION).not_to be nil
  end

  describe 'versions' do
    before do
      @first_version = JSON.parse(First::V1::BaseDocs.generate_json.to_json)
      @second_version = JSON.parse(Second::BaseDocs.generate_json.to_json)
    end

    it "have different serializers count" do
      expect(@first_version["definitions"].keys.count).not_to eq(@second_version["definitions"].keys.count)
    end

    it "have different controllers count" do
      expect(@first_version["paths"].keys.count).not_to eq(@second_version["paths"].keys.count)
    end
  end

  describe 'configuration' do
    let(:config) { First::V1::BaseDocs.api_version.configuration }

    it "contains correct title" do
      expect(config.title).to eq('Users API')
    end

    it "contains correct version" do
      expect(config.version).to eq('1.0')
    end

    it "contains authorization" do
      expect(config.authorization).to eq(true)
    end

    it "contains correct error model" do
      expect(config.error_model).to eq(:error_model)
    end

    it "contains correct error descriptions" do
      expect(config.error_desc).to eq({
        '401' => "Unauthorized",
        '403' => "Forbidden",
        '404' => "Not found",
        '422' => "Unprocessable Entity"
      })
    end
  end

  describe 'serializers' do
    before do
      @data = JSON.parse(First::V1::BaseDocs.generate_json.to_json)
    end

    it 'has correct models' do
      expect(@data["definitions"].keys).to match_array(["file", "error_model", "attachment", "create_attachment"])
    end

    it 'has correct references' do
      expect(@data["definitions"]["attachment"]["properties"]["attachment"]["properties"].keys).to include("file")
    end

    it 'has allowed values' do
      expect(@data["definitions"]["attachment"]["properties"]["attachment"]["properties"]["download_url"]["enum"]).to eq(["Slug1", "Slug2"])
      expect(@data["definitions"]["attachment"]["properties"]["attachment"]["properties"]["subject_type"]["enum"]).to eq(["Company"])
    end
  end

  describe 'controllers' do
    before do
      @data = JSON.parse(First::V1::BaseDocs.generate_json.to_json)
    end

    it 'has correct routes' do
      expect(@data["paths"].keys).to eq(["/attachments/{id}", "/attachments/{id}/download", "/attachments"])
    end

    it 'has correct methods' do
      expect(@data["paths"].values.map(&:keys).flatten).to match_array(["get", "get", "post", "delete"])
    end

    it 'has correct response' do
      expect(@data["paths"]['/attachments']["post"]['responses'].keys).to include("200")
    end

    it 'has correct errors' do
      expect(@data["paths"]['/attachments']["post"]['responses'].keys).to include("401", "403", "422")
    end
  end

  context 'with resource errors' do
    it 'throws exception' do
      expect do
        WrongResource::BaseDocs.generate_json
      end.to raise_error(UndefinedSerializersError, /attachment_extended|attachment|create_attachment/)
    end
  end

  context 'with imports for resource' do
    it 'does not throw exception' do
      expect do
        First::V2::BaseDocs.generate_json
      end.not_to raise_error
    end

    describe 'serializers' do
      before do
        @data = JSON.parse(First::V2::BaseDocs.generate_json.to_json)
      end

      it 'has correct models' do
        expect(@data["definitions"].keys).to match_array(["file", "error_model", "attachment", "create_attachment"])
      end

      it 'has correct references' do
        expect(@data["definitions"]["attachment"]["properties"]["attachment"]["properties"].keys).to include("file")
      end

      it 'has allowed values' do
        expect(@data["definitions"]["attachment"]["properties"]["attachment"]["properties"]["download_url"]["enum"]).to eq(["Slug1", "Slug2"])
        expect(@data["definitions"]["attachment"]["properties"]["attachment"]["properties"]["subject_type"]["enum"]).to eq(["Company"])
      end
    end

    describe 'controllers' do
      before do
        @data = JSON.parse(First::V2::BaseDocs.generate_json.to_json)
      end

      it 'has correct routes' do
        expect(@data["paths"].keys).to eq(["/attachments/{id}", "/attachments"])
      end

      it 'has correct methods' do
        expect(@data["paths"].values.map(&:keys).flatten).to match_array(["get", "post"])
      end

      it 'has correct response' do
        expect(@data["paths"]['/attachments']["post"]['responses'].keys).to include("200")
      end

      it 'has correct errors' do
        expect(@data["paths"]['/attachments']["post"]['responses'].keys).to include("401", "403", "422")
      end
    end
  end

  context 'with reference errors' do
    it 'throws exception' do
      expect do
        WrongReference::BaseDocs.generate_json
      end.to raise_error(UndefinedSerializersError, /attachment/)
    end
  end

  context 'with imports for references' do
    it 'does not throw exception' do
      expect do
        ImportReference::BaseDocs.generate_json
      end.not_to raise_error
    end

    describe 'serializers' do
      before do
        @data = JSON.parse(ImportReference::BaseDocs.generate_json.to_json)
      end

      it 'has correct models' do
        expect(@data["definitions"].keys).to match_array(["file", "error_model", "attachment"])
      end

      it 'has correct references' do
        expect(@data["definitions"]["file"]["properties"]["file"]["properties"].keys).to include("attachments")
      end
    end
  end
end
