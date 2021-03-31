class Api::V1::CoffeesController < Api::V1::ApiController

  swagger_controller :coffees, "Coffee Management"

  def index
    @coffees = Coffee.all
    json_response(@coffees)
  end

  # swagger
  swagger_api :index do
    summary "See a list of all coffees"
    notes "No params to input to see a list of all coffees"
    response :success
    response :not_found
    response :unauthorized
  end

  def search
    @results = Coffee.search(params[:q])
    if @results.any?
      json_response(@results)
    else
      render status: 404, json: {
        message: "Nope no results lol"
      }
    end
  end

  # swagger
  swagger_api :search do
    summary "Search for a specific blend by its name"
    notes "params are blend_name"
    param :query, "q", :string, :required, "Blend of coffee"
    response :success
    response :not_found
    response :unauthorized
  end

  def show
    @coffee = Coffee.find(params[:id])
    json_response(@coffee)
  end

  # swagger
  swagger_api :show do
    summary "Show a single coffee"
    notes "shows a specific product"
    param :path, :id, :integer, :optional, "coffee Id"
    response :success
    response :not_found
    response :unauthorized
  end

  def create
    if @coffee = Coffee.create!(coffee_params)
      render status: 201, json: {
        message: "You have successfully created a coffee",
        coffee: @coffee
      }
    end
  end

  # swagger
  swagger_api :create do
    summary "Creates a new Coffee"
    param :form, :blend_name, :string, :required, "Blend Name"
    param :form, :origin, :string, :required, "Origin"
    param :form, :notes, :string, :required, "Blend aroma notes"
    response :unauthorized
    response :not_acceptable
  end

  def update
    @coffee = Coffee.find(params[:id])
    if @coffee.update!(coffee_params)
      render status: 200, json: {
        message: "This coffee has been successfully updated.",
        coffee: @coffee
      }
    else
      render json: { error: @coffee.errors.messages }, status: 422
    end
  end

  # swagger
  swagger_api :update do
    summary "Updates an existing coffee"
    param :path, :id, :integer, :required, "Coffee Id"
    param :form, :blend_name, :string, :required, "Blend Name"
    param :form, :origin, :string, :required, "Origin"
    param :form, :notes, :string, :required, "Blend aroma notes"
    response :unauthorized
    response :not_found
    response :not_acceptable
  end

  def destroy
    @coffee = Coffee.find(params[:id])
    if @coffee.destroy!
      render status: 200, json: {
        message: "You have successfully deleted the coffee with id #{@coffee.id}"
      }
    end
  end

  # swagger
  swagger_api :destroy do
    summary "Deletes an existing Coffee"
    param :path, :id, :integer, :optional, "Coffee Id"
    response :unauthorized
    response :not_found
  end

  private def coffee_params
    params.permit(:blend_name, :origin, :notes)
  end
end
