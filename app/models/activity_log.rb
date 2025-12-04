# app/models/activity_log.rb
class ActivityLog < ApplicationRecord
  belongs_to :record, polymorphic: true, optional: true
  belongs_to :user, optional: true

  validates :action, presence: true

  # Return metadata as a Hash
  def metadata_hash
    metadata || {}
  end
end
