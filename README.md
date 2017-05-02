# Api Schema
Provides a framework and DSL for describing APIs and generate swagger-json using minimalist, schema.db-like syntax.

<p align="center">
    <a href="#installation">Installation</a> | <a href="#usage">Usage</a> | <a href="#license">License</a>
</p>

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'api_schema'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install api_schema

## Usage

Just add `include ApiSchema` and configurations to your base class and inherit from it.
To generate json use `BaseDocs.generate_json` method.

#### BaseDocs

```ruby
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
  end
end
```

#### UsersController

```ruby
module V1
  module ControllersDocs
    class UsersController < BaseDocs

      get do
        path_param :id, :integer
        name 'Get User'
        desc 'Returns user with provided id'
        response 200, :user
        error! 401, 403, 404, 422
      end
    end
  end
```

#### UserSerializer

```ruby
module V1
  module SerializersDocs
    class UserSerializer < BaseDocs

      serializer :user do |f|
        f.integer  :id, required: true
        f.string   :email, required: true
        f.string   :name
      end
    end
  end
```

### Serializers

To describe serializers you can use `serializer` and `array_serializer` methods.

**Here `:user` and `:users` are unique identifiers**

For **member** responses:

```ruby
serializer :user do |f|
  f.integer  :id, required: true
  f.string   :email, required: true
  f.string   :name
end
```

Will have such a structure:

```json
{
  "user": {
    "id": 1,
    "email": "john.doe.gmail.com",
    "name": "John Doe"
  }
}
```

For **collection** responses:

```ruby
array_serializer :users do |f|
  f.reference :meta
  f.reference :user, type: :array
end
```

Will have such a structure:

```json
{
  "meta": {...},
  "users": [
    {
      "id": 1,
      "email": "john.doe.gmail.com",
      "name": "John Doe"
    },
    {...}]
}
```

Then you can use this descriptions in the controllers with identifiers:

```ruby
response 200, :user
```

```ruby
response 200, :users
```

#### References

To user nested descriptions, you can use `reference` method:

```ruby
serializer :file do |f|
  f.integer :file_name, required: true
  f.string  :file_url, required: true
end
```

```ruby
serializer :attachment do |f|
  f.integer   :id, required: true
  f.reference :file
end
```

#### Parents

To inherit fields from another serializer, you can use `parent` parameter:

```ruby
serializer :file do |f|
  f.integer   :file_name, required: true
  f.string    :file_url, required: true
end
```

```ruby
serializer :attachment, parent: :file do |f|
  f.integer   :id, required: true
end
```

### Controllers

#### Endpoints

To describe endpoints you can use `get`, `post`, `put`, `patch` methods.

Get **collection**:

```ruby
get do
  query_param :query, :string
  query_param :sort_by, :string
  name 'List Users'
  desc "Returns list of the users"
  response 200, :users
  error! 401, 403, 422
end
```

Will produce `/users` endpoint.

To get **member** you should use `path_param` method:

```ruby
get do
  path_param :id, :integer
  name 'Get User'
  desc 'Returns user with provided id'
  response 200, :user
  error! 401, 403, 422
end
```

Will produce `/users/{id}` endpoint.

By default gem uses controller's name to generate endpoints, but you can make custom by passing first argument:

```ruby
get 'people' do
  path_param :id, :integer
  name 'Get User'
  desc 'Returns user with provided id'
  response 200, :user
  error! 401, 403, 422
end
```

Will produce `/people/{id}` endpoint.

Use `extra_path` argument to add extra path to the endpoint

```ruby
get extra_path: :read do
  path_param :id, :integer
  name 'Read Notification'
  desc 'Reads notification with provided id'
  response 200
  error! 401, 403, 422
end
```

Will produce `/notification/{id}/read` endpoint.

#### Parameters

To describe each endpoint you can use `header`, `body`, `path_param`, `query_param`

`header` and `body`:

```ruby
post do
  header :token, :string
  body :create_user
  name 'Create User'
  desc 'Creates and returns new user'
  response 200, :user
  error! 401, 403, 422
end
```

To describe body of the request you can use `request_body` method. It's just an alias for serializer:

```ruby
request_body :create_user do |f|
  f.string   :email, required: true
  f.string    :first_name, required: true
  f.string    :last_name, required: true
end
```

## Dependencies

- [Active Support](https://github.com/rails/rails/tree/master/activesupport)
- [Swagger::Blocks](https://github.com/fotinakis/swagger-blocks)


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
