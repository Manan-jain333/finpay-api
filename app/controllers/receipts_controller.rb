class ReceiptsController < ApplicationController
  def create
    receipt = Receipt.new(receipt_params)

    if receipt.save
      render json: ReceiptSerializer.new(receipt).serialize, status: :created
    else
      render json: { errors: receipt.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    receipt = Receipt.find(params[:id])
    receipt.destroy
    head :no_content
  end

  private

  def receipt_params
    params.require(:receipt).permit(:file_url, :expense_id)
  end
end
