# frozen_string_literal: true

class Factory
  def call(params, owner)
    params[:type].constantize.new.new_wallet(params, owner)
  end
end

class Wallet < ApplicationRecord
  TransferResult = Struct.new(:status, :error_message)

  has_and_belongs_to_many :users
  has_and_belongs_to_many :wallet_transactions
  belongs_to :currency
  has_many :invites

  scope :public_wallets, -> { where(is_private: false) }
  scope :no_pesonal, -> { where.not(type: 'Personal') }

  def created(params, owner)
    params[:wallet_identity] = wallet_identity(params)
    Wallet.transaction do
      Factory.new.call(params, owner)
    end
  end

  def withdraw_money(transfer, sum_for_transfer)
    withdraw_error = validate_error(transfer, sum_for_transfer)
    return withdraw_error if withdraw_error.present?

    self.capital = balance - sum_for_transfer
    save!
    TransferResult.new(:done, nil)
  end

  def receiving_money(_transfer, sum_for_transfer)
    self.capital = balance + sum_for_transfer

    save!
    TransferResult.new(:done, nil)
  end

  def encrypte_pin(pin)
    crypt.encrypt_and_sign(pin)
  end

  def decrypt_pin
    crypt.decrypt_and_verify(encrypted_pin)
  end

  def crypt
    key = Rails.application.config.secret_key
    ActiveSupport::MessageEncryptor.new(key)
  end

  def wallet_identity(params)
    "#{params[:currency_id]}-#{SecureRandom.hex(8)}"
  end

  def validate_error(transfer, sum_for_transfer)
    if self.capital <= sum_for_transfer
      TransferResult.new(:failed, 'not enough money')
    elsif admin_id != transfer.initiator_id
      TransferResult.new(:failed,
                         'Only admin can withdraw money from this wallet')
    end
  end

  def balance
    WalletBalance.perform(wallet: self)
  end
end
