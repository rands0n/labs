require_relative '../config/sequel'

module ExpenseTracker
  RecordResult = Struct.new(:success?, :expense_id, :error_message)

  class Ledger
    def record(expense)
      unless expense.key?('payee')
        return RecordResult.new(false, nil, 'Invalid expense: `payee` is required')
      end

      DB[:expenses].insert(expense)
      id = DB[:expenses].max(:id)
      RecordResult.new(true, id, nil)
    end

    def expense_on(date)
      DB[:expenses].where(date: date).all
    end
  end
end
