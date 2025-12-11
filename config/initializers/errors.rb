# Explicitly require custom error classes
# This ensures Errors module is loaded even if autoloading doesn't pick it up
require Rails.root.join('app/errors/custom_exceptions')
require Rails.root.join('app/errors/invalid_expense_error')
