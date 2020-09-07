# frozen_string_literal: true

class WalletBalance < BaseQuery
  # @attr_reader params [Hash]:
  # - wallet: [Family]
  # -initiator_id: [Integer]

  def call
    to_transactions_sum - from_transactions_sum
  end

  private

  def to_transactions_sum
    wallet_transactions
      .select('sum(transfered_money - (case when tax_paid_by_the_recipient then tax else 0 end))')
      .where(wallet_to_id: params[:wallet].id)
      .as_json[0]['sum'].to_i
  end

  def from_transactions_sum
    wallet_transactions
      .select('sum(transfered_money + (case when tax_paid_by_the_recipient then 0 else tax end))')
      .where(wallet_from_id: params[:wallet].id)
      .as_json[0]['sum'].to_i
  end

  def wallet_transactions
    @wallet_transactions ||= params[:wallet].wallet_transactions.done
  end
end
