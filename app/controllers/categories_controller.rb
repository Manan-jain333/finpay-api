# app/controllers/categories_controller.rb
class CategoriesController < ApplicationController
  include AuthenticatedController

  def index
    categories = Category.all
    render json: CategorySerializer.new(categories).serialize, status: :ok
  end

  def show
    category = Category.find(params[:id])
    render json: CategorySerializer.new(category).serialize, status: :ok
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
      render json: CategorySerializer.new(category).serialize, status: :ok
    else
      render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    head :no_content
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
