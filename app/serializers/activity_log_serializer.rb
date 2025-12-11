class ActivityLogSerializer
  include Alba::Resource

  attributes :id, :action, :metadata, :created_at

  one :user, resource: UserSerializer, optional: true
end
