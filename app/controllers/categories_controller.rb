class CategoriesController < ApplicationController
  include AuthenticatedController
  
  def index
    categories = Category.all
    render json: CategorySerializer.new(categories).serialize
  end

  def show
    category = Category.find(params[:id])
    render json: CategorySerializer.new(category).serialize
  end

  def create
    category = Category.new(category_params)

    if category.save
      render json: CategorySerializer.new(category).serialize, status: :created
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    category = Category.find(params[:id])

    if category.update(category_params)
      render json: CategorySerializer.new(category).serialize
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    category = Category.find(params[:id])
    category.destroy
    head :no_content
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
