class ExpenseSerializer
  include Alba::Resource

  attributes :id, :title, :amount, :date

  one :category, resource: CategorySerializer
  many :receipts, resource: ReceiptSerializer
end
