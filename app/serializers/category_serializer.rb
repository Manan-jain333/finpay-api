class CategorySerializer
  include Alba::Resource

  attributes :id, :name, :description

#   many :expenses, resource: ExpenseSerializer
end
