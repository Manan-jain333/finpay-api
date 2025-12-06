# app/services/math_service.rb
class MathService < ApplicationService
  def initialize(a, b)
    @a = a
    @b = b
  end

  def call
    @a + @b
  end
end
