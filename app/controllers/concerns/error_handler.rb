# app/controllers/concerns/error_handler.rb
module ErrorHandler
  extend ActiveSupport::Concern

  class_methods do
    def handle_errors(*exception_classes, status: :unprocessable_entity)
      rescue_from(*exception_classes) do |e|
        Rails.logger.error "Handled #{e.class}: #{e.message}\n#{e.backtrace&.first(5).join("\n")}" if Rails.env.development?
        render json: { success: false, message: e.message }, status: status
      end
    end
  end
end
