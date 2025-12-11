class Api::V1::CompaniesController < ApplicationController
  def create
    company = Company.new(company_params)
    if company.save
      render json: { message: "Company created", company: company }, status: :created
    else
      render json: { errors: company.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :subdomain)
  end
end
