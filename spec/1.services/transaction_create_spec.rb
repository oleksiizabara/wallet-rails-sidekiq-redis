require 'rails_helper'

RSpec.describe TransactionCreate do
  let(:currency) { FactoryBot.create(:currency) }
  let(:user) { FactoryBot.create(:user) }
  let(:personal_wallet) { FactoryBot.create(:personal) }
  let(:personal_wallet_second) { FactoryBot.create(:personal) }

  context 'Test perform method' do
    let(:params) do
      {
        type: 'replenish_your_wallet',
        wallet_to_id: personal_wallet.id,
        wallet_from_id: nil,
        wallet_to: nil,
        tax_paid_by_the_recipient: nil,
        transfered_money: 100
      }
    end

    let(:between_params) do
      {
        type: 'between_your_wallets',
        wallet_to_id: personal_wallet_second.id,
        wallet_from_id: personal_wallet.id,
        wallet_to: nil,
        tax_paid_by_the_recipient: nil,
        transfered_money: 1000
      }
    end

    def valid_transaction?(transaction)
      expect(transaction.transaction_type).to eq('replenish_your_wallet')
      expect(transaction.tax).to eq(1)
      expect(transaction.currency_id).to eq(personal_wallet.currency_id)
      expect(transaction.transfered_money).to eq(100)
      expect(transaction.initiator_id).to eq(user.id)
      expect(transaction.tax_paid_by_the_recipient).to be false
      expect(transaction.error_message).to be nil
    end

    def valid_between_transaction?(transaction)
      expect(transaction.transaction_type).to eq('between_your_wallets')
      expect(transaction.tax).to eq(5)
      expect(transaction.currency_id).to eq(personal_wallet_second.currency_id)
      expect(transaction.transfered_money).to eq(1000)
      expect(transaction.initiator_id).to eq(user.id)
      expect(transaction.tax_paid_by_the_recipient).to be false
      expect(transaction.error_message).to be nil
    end

    it "Should build transaction with saving" do
      personal_wallet.users << user
      personal_wallet.update(admin_id: user.id)
      transaction = TransactionCreate.perform(transaction_params: params, user: user)

      expect(transaction).to be_a(WalletTransaction)
      expect(transaction.id).not_to be nil
      valid_transaction?(transaction)
    end

    it "Should build transaction between_your_wallets with saving" do
      personal_wallet.users << user
      personal_wallet_second.users << user
      personal_wallet.update(admin_id: user.id)
      personal_wallet_second.update(admin_id: user.id)
      transaction = TransactionCreate.perform(transaction_params: between_params, user: user)

      expect(transaction).to be_a(WalletTransaction)
      expect(transaction.id).not_to be nil
      valid_between_transaction?(transaction)
    end
  end
end