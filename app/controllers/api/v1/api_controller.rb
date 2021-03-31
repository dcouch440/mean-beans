class Api::V1::ApiController < ApplicationController

  before_action :validate_api_key!

  class << self
    Swagger::Docs::Generator::set_real_methods

    def inherited(subclass)
      super
      subclass.class_eval do
        setup_basic_api_documentation
      end
    end

    private

    def setup_basic_api_documentation
      %i[index show create update destroy search].each do |api_action|
        swagger_api api_action do
          param :header, "X-Api-Key", :string, :required, User.first.api_key
        end
      end
    end
  end

  private

  def has_valid_api_key?
    User.where(api_key: request.headers['X-Api-Key']).any?
  end

  def validate_api_key!
    render status: 403, json: {
      message: "Invalid API key"
    } unless has_valid_api_key?
  end
end
