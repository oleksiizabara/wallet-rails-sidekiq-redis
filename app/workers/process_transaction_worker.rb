# frozen_string_literal: true

class ProcessTransactionWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(transaction_id)
    WalletTransaction.transaction do
      transaction = WalletTransaction.find(transaction_id)
      TransactionStateMachine::InitState.perform(transaction: transaction)
    end
  end
end
