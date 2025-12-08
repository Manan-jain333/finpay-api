require 'rails_helper'

RSpec.describe ApplicationService do
  it 'raises NotImplementedError when #call not implemented' do
    klass = Class.new(ApplicationService)
    expect { klass.new.call }.to raise_error(NotImplementedError)
  end

  it 'allows .call to delegate to instance' do
    klass = Class.new(ApplicationService) do
      def initialize(a, b)
        @a = a
        @b = b
      end

      def call
        @a * @b
      end
    end

    expect(klass.call(3, 4)).to eq(12)
  end
end
