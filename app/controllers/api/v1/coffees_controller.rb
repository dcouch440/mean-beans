class Api::V1::CoffeesController < Api::V1::ApiController

  swagger_controller :coffees, "Coffee Management"

  def index
    @coffees = Coffee.all
    json_response(@coffees)
  end

  swagger_api :index do
    summary "To see a list of all coffees"
    notes "No params to input to see a list of all coffees"
    response :success
    response :not_found
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

  swagger_api :search do
    summary "To search for a specific blend by its name"
    notes "params are blend_name"
    param :query, "q", :string, :required, "Blend of coffee"
    response :success
    response :not_found
  end

  def show
    @coffee = Coffee.find(params[:id])
    json_response(@coffee)
  end

  def create
    if @coffee = Coffee.create!(coffee_params)
      render status: 201, json: {
        message: "You have successfully created a coffee",
        coffee: @coffee
      }
    end
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

  def destroy
    @coffee = Coffee.find(params[:id])
    if @coffee.destroy!
      render status: 200, json: {
        message: "You have successfully deleted the coffee with id #{@coffee.id}"
      }
    end
  end

  private def coffee_params
    params.permit(:blend_name, :origin, :notes)
  end
end
