# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TransactionStateMachine::InitState do
  let(:currency) { FactoryBot.create(:currency) }
  let(:user) { FactoryBot.create(:user) }
  let(:personal_wallet) { FactoryBot.create(:personal) }
  let(:personal_wallet_second) { FactoryBot.create(:personal) }

  context 'Test perform method' do
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

    def valid_between_transaction?(transaction)
      expect(transaction.transaction_type).to eq('between_your_wallets')
      expect(transaction.tax).to eq(5)
      expect(transaction.currency_id).to eq(personal_wallet_second.currency_id)
      expect(transaction.transfered_money).to eq(1000)
      expect(transaction.initiator_id).to eq(user.id)
      expect(transaction.tax_paid_by_the_recipient).to be false
      expect(transaction.error_message).to be nil
    end

    def valid_confirm(transaction)
      expect(transaction.done?).to be true
      expect(transaction.wallets.first.capital).to eq(98_995)
      expect(transaction.wallets.second.capital).to eq(101_000)
      expect(transaction.wallets.first.balance).to eq(98_995)
      expect(transaction.wallets.second.balance).to eq(101_000)
    end

    it 'Should build transaction between_your_wallets with saving' do
      personal_wallet.users << user
      personal_wallet_second.users << user
      personal_wallet.update(admin_id: user.id)
      personal_wallet_second.update(admin_id: user.id)
      TransactionCreate.perform(transaction_params: {
                                  type: 'replenish_your_wallet',
                                  wallet_to_id: personal_wallet_second.id,
                                  wallet_to: nil,
                                  tax_paid_by_the_recipient: nil,
                                  transfered_money: 100_000
                                }, user: user).update(status: :done)
      TransactionCreate.perform(transaction_params: {
                                  type: 'replenish_your_wallet',
                                  wallet_to_id: personal_wallet.id,
                                  wallet_to: nil,
                                  tax_paid_by_the_recipient: nil,
                                  transfered_money: 100_000
                                }, user: user).update(status: :done)

      transaction = TransactionCreate.perform(transaction_params: between_params, user: user)

      expect(transaction).to be_a(WalletTransaction)
      expect(transaction.id).not_to be nil
      valid_between_transaction?(transaction)

      TransactionStateMachine::InitState.perform(transaction: transaction)

      valid_confirm(transaction)
    end
  end
end
