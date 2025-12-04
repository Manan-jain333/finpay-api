# app/controllers/receipts_controller.rb
class ReceiptsController < ApplicationController
  include AuthenticatedController

  def create
    receipt = Receipt.new(receipt_params)
    # binding.pry
    if receipt.save
      render json: ReceiptSerializer.new(receipt).serialize, status: :created
    else
      render json: { errors: receipt.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    Receipt.find(params[:id]).destroy
    head :no_content
  end

  private

  def receipt_params
    params.require(:receipt).permit(:file_url, :expense_id)
  end
end
