class ExpensesListSerializer
  include Alba::Resource

  root_key :expenses

  attributes :id, :title, :amount, :status, :date

  one :category do
    attributes :id, :name
  end

  one :employee, resource: UserSerializer, if: proc { |expense| expense.employee.present? }
end
