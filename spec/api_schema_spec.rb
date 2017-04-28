require "spec_helper"

SWAGGER_JSON_EXAMPLE = open(File.expand_path('../example.json', __FILE__)).read


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
    f.string    :download_url, required: true
    f.string    :slug, required: true, desc: "String representing the human id, composed by subject slug, model name, sequential id. (i.e 'milton-arps-zabel-3311-transaction-27-new-attachment-1')"
    f.string    :organization_id, required: true
    f.string    :subject_id
    f.string    :subject_type
    f.string    :created_at, required: true
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
    error! 401, 403, 404, 422
  end

  delete do
    path_param :id, :string
    name 'Delete attachment'
    desc 'Delete an attachment'
    response 200
    error! 401, 403, 404, 422
  end

  request_body :create_attachment, title: 'attachment' do |f|
    f.string :organization_id, required: true
    f.string :subject_id
    f.string :subject_type
  end
end


describe ApiSchema do
  it "has a version number" do
    expect(ApiSchema::VERSION).not_to be nil
  end

  describe 'configuration' do
    let(:config) { BaseDocs.api_version.configuration }

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
end
