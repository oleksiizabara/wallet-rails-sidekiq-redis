# frozen_string_literal: true

class TransactionCreate < BaseService
  # @attr_reader params [Hash]:
  # - user: [User]
  # - transaction_params: [Hash]

  def call
    WalletTransaction.transaction do
      transaction.save!
      transaction_validate
      add_users_and_wallets
      transaction
    end
  end

  protected

  def transaction
    @transaction ||= Builders::TransactionBuilder.build do |builder|
      builder.build_initiator(user.id)
      builder.build_type(transaction_params[:type])
      builder.build_currency(wallet_to)
      builder.build_money(transaction_params[:transfered_money],
                          transaction_params[:tax_paid_by_the_recipient])
    end
  end

  def wallet_from
    return if transaction_params[:wallet_from_id].blank?

    @wallet_from ||= @user.wallets.find(transaction_params[:wallet_from_id])
  end

  def wallet_to
    @wallet_to ||=
      begin
        if transaction_params[:wallet_to].present?
          Wallet.find_by(identity: transaction_params[:wallet_to])
        elsif transaction_params[:wallet_to_id].present?
          Wallet.find(transaction_params[:wallet_to_id].to_i)
        end
      end
    raise StandardError, 'recipient wallet not found' if @wallet_to.blank?

    @wallet_to
  end

  def transaction_validate
    valid_wallets
    valid_currency
  end

  def valid_wallets
    return true if wallet_from.blank? || wallet_from.id != wallet_to.id

    transaction.update(status: :failed, error_message: 'invalid wallet')
    false
  end

  def valid_currency
    return if wallet_from.blank? || \
              wallet_from.currency_id == wallet_to.currency_id

    transaction.update(status: :failed,
                       error_message: 'currencies is not equal')
  end

  def add_users_and_wallets
    add_wallets
    add_users
  end

  def add_wallets
    transaction.wallets << wallet_to
    transaction.update(wallet_to_id: wallet_to.id)
    return if wallet_from.blank? || !valid_wallets

    transaction.wallets << wallet_from
    transaction.update(wallet_from_id: wallet_from.id)
  end

  def add_users
    transaction.users << @user
    return if @wallet_to.admin_id == @user.id

    second_user = User.find(@wallet_to.admin_id)
    transaction.users << second_user
  end

  def transaction_params
    @transaction_params ||= params[:transaction_params]
  end

  def user
    @user ||= params[:user]
  end
end
