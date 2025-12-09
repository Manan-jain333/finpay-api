require 'rails_helper'

RSpec.describe MathService, type: :service do
  it 'adds two numbers via instance call' do
    svc = MathService.new(2, 5)
    expect(svc.call).to eq(7)
  end

  it 'supports .call class method' do
    expect(MathService.call(10, 15)).to eq(25)
  end
end
