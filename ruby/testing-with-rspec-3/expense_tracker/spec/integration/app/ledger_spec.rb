require_relative '../../../app/ledger'

module ExpenseTracker
  RSpec.describe Ledger, :aggregate_failures, :db do
    let(:ledger) { described_class.new }
    let(:expense) { { 'payee' => 'Starbucks', 'amount' => 5.75, 'date' => '2017-06-10' } }

    describe '#record' do
      context 'with a valid expense' do
        it 'saves the expense in the DB' do
          result = ledger.record(expense)

          expect(result).to be_success
          expect(DB[:expenses].all).to match [a_hash_including(
            payee: 'Starbucks',
            amount: 5.75,
            date: Date.iso8601('2017-06-10')
          )]
        end
      end

      context 'when a expense lack a payee' do
        it 'reject the expense as invalid' do
          expense.delete('payee')

          result = ledger.record(expense)

          expect(result).not_to be_success
          expect(result.expense_id).to eq nil
          expect(result.error_message).to include '`payee` is required'

          expect(DB[:expenses].count).to eq 0
        end
      end
    end

    describe '#expense_on' do
      it 'returns all expenses for the provided date' do
        result_1 = ledger.record(expense.merge('date' => '2017-06-10'))
        result_2 = ledger.record(expense.merge('date' => '2017-06-10'))
        result_3 = ledger.record(expense.merge('date' => '2017-06-11'))

        expect(ledger.expense_on('2017-06-10')).to contain_exactly(
          a_hash_including(payee: 'Starbucks'),
          a_hash_including(payee: 'Starbucks')
        )
      end

      it 'returns a blank array when there are no matching expenses' do
        expect(ledger.expense_on('2017-06-10')).to eq []
      end
    end
  end
end
