require 'rails_helper'

RSpec.describe ActivityLog, type: :model do
  it 'is valid with an action' do
    log = ActivityLog.new(action: 'create')
    expect(log).to be_valid
  end

  it 'is invalid without an action' do
    log = ActivityLog.new(action: nil)
    expect(log).to be_invalid
    expect(log.errors[:action]).to include("can't be blank")
  end
end
