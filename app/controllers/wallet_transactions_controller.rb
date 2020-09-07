# frozen_string_literal: true

class WalletTransactionsController < ApplicationController
  respond_to :html
  before_action :authenticate_user!
  before_action :set_wallet_transaction, only: %i[show edit update destroy]

  # GET /wallet_transactions/1
  # GET /wallet_transactions/1.json
  def show
    @user = current_user
    @initiator = User.find(@wallet_transaction.initiator_id)
    if @wallet_transaction.wallet_from_id.present?
      @wallet_from = Wallet.find(@wallet_transaction.wallet_from_id).identity
    end
    @wallet_to = Wallet.find(@wallet_transaction.wallet_to_id).identity
  end

  # GET /wallet_transactions/new
  def new
    @user = current_user
    t = Wallet.table_name
    query = "#{t}.admin_id = #{current_user.id} or #{t}.type = 'Family'"
    @wallets_from = current_user.wallets.where(query)
  end

  # POST /confirm_transaction/:id
  def confirm_transaction
    @transaction = WalletTransaction.new_transaction.find_by(initiator_id: current_user.id)
    raise StandardError, 'transaction not found' if @transaction.blank?

    @transaction.update(status: :in_progress)

    ProcessTransactionWorker.perform_async(@transaction.id)
    respond_with @transaction, location: @transaction
  end

  # POST /wallet_transactions
  # POST /wallet_transactions.json
  def create
    @wallet_transaction = TransactionCreate.perform(transaction_params: wallet_transaction_params,
                                                    user: current_user)
    respond_to do |format|
      if @wallet_transaction.save
        format.html { redirect_to @wallet_transaction, notice: 'Wallet transaction was successfully created.' }
        format.json { render :show, status: :created, location: @wallet_transaction }
      else
        format.html { render :new }
        format.json { render json: @wallet_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallet_transactions/1
  # PATCH/PUT /wallet_transactions/1.json
  def update
    respond_to do |format|
      if @wallet_transaction.update(wallet_transaction_params)
        format.html { redirect_to @wallet_transaction, notice: 'Wallet transaction was successfully updated.' }
        format.json { render :show, status: :ok, location: @wallet_transaction }
      else
        format.html { render :edit }
        format.json { render json: @wallet_transaction.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_wallet_transaction
    @wallet_transaction = current_user.wallet_transactions.find(params[:id])
  end

  def wallet_transaction_params
    params.require(:wallet_transaction).permit(:type, :wallet_to_id,
                                               :wallet_from_id, :wallet_to,
                                               :tax_paid_by_the_recipient,
                                               :transfered_money)
  end
end
