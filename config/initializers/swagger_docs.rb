# config/initializers/swagger_docs.rb

class Swagger::Docs::Config
    def self.transform_path(path, api_version)
      # Make a distinction between the APIs and API documentation paths.
      "apidocs/#{path}"
    end
  end
  
  Swagger::Docs::Config.base_api_controller = ActionController::API 
  
  Swagger::Docs::Config.register_apis({
    "1.0" => {
      # the extension used for the API
      :api_extension_type => :json,
      # the output location where your .json files are written to
      :api_file_path => "public/apidocs",
      # the URL base path to your API (make sure to change this if you are not using localhost:3000)
      :base_path => "http://localhost:3000",
      # if you want to delete all .json files at each generation
      :clean_directory => false,
      # add custom attributes to api-docs
      :attributes => {
        :info => {
          "title" => "Chore Tracker API",
          "description" => "Uses swagger ui and docs to document the ChoreTracker API"
        }
      }
    }
  })