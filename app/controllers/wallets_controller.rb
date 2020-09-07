# frozen_string_literal: true

class WalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_wallet, only: %i[show edit update destroy]

  # GET /wallets
  # GET /wallets.json
  def index
    if params[:user_id].blank?
      @wallets = current_user.wallets
    else
      user = User.find(params[:user_id])
      @wallets = user.wallets.public_wallets
    end
  end

  # GET /wallets/1
  # GET /wallets/1.json
  def show
    @user = current_user
  end

  # GET /money_transfers
  def money_transfers; end

  # GET /wallets/new
  def new
    @wallet = current_user.wallets.new
  end

  # GET /wallets/1/edit
  def edit; end

  # POST /wallets
  # POST /wallets.json
  def create
    @wallet = Wallet.new

    respond_to do |format|
      if @wallet.created(wallet_params, current_user)
        format.html { redirect_to @wallet, notice: 'Wallet was successfully created.' }
        format.json { render :show, status: :created, location: @wallet }
      else
        format.html { render :new }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /wallets/1
  # PATCH/PUT /wallets/1.json
  def update
    respond_to do |format|
      if @wallet.update(wallet_params)
        format.html { redirect_to @wallet, notice: 'Wallet was successfully updated.' }
        format.json { render :show, status: :ok, location: @wallet }
      else
        format.html { render :edit }
        format.json { render json: @wallet.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_wallet
    if params[:user_id].blank?
      @wallet = current_user.wallets.find(params[:id])
    else
      user = User.find(params[:user_id])
      @wallet = user.wallets.public_wallets.find(params[:id])
    end
  end

  def wallet_params
    params.require(:wallet).permit(:description, :type, :currency_id, :is_private)
  end
end
