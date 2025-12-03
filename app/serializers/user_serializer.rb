class UserSerializer
  include Alba::Resource

  attributes :id, :email, :role
end
