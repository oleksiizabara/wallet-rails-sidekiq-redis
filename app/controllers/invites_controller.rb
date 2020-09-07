# frozen_string_literal: true

class InvitesController < ApplicationController
  respond_to :html
  before_action :authenticate_user!
  before_action :set_invite, only: %i[show edit update destroy]
  before_action :set_wallet_for_invite, only: %i[new create]

  # GET /invites
  # GET /invites.json
  def index
    @invites = current_user.invites.where(is_declined: nil).all
  end

  # GET /invites/1
  # GET /invites/1.json
  def show; end

  # GET /invites/new
  def new
    @invite = NewInvite.new
  end

  # GET /invites/1/edit
  def edit
    @from_user = User.find(@invite.from_id)
    @wallet_from = @invite.wallet
  end

  # POST /invites
  # POST /invites.json
  def create
    @invite = NewInvite.new(invite_params, current_user)
    @invite.call
    respond_with @invite, location: wallet_path(id: invite_params[:wallet_id])
  end

  # PATCH/PUT /invites/1
  # PATCH/PUT /invites/1.json
  def update
    respond_to do |format|
      if @invite.proces(confirmed_params, current_user)
        format.html { redirect_to @invite, notice: 'Invite was successfully updated.' }
        format.json { render :show, status: :ok, location: @invite }
      else
        format.html { render :edit }
        format.json { render json: @invite.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_invite
    @invite = Invite.find(params[:id])
  end

  def set_wallet_for_invite
    table = Wallet.table_name
    privacy_query = "(#{table}.is_private is true AND " \
                    " #{table}.admin_id = #{current_user.id}) " \
                    " OR #{table}.is_private is false"
    @wallet = current_user.wallets.where(privacy_query)
                          .where.not(type: 'Personal')
                          .find(params[:wallet_id] || params['new_invite'][:wallet_id])
  end

  def invite_params
    params.require(:new_invite).permit(:wallet_id, :user_email, :message, :daily_limit)
  end

  def confirmed_params
    params.permit(:is_confirmed, :is_declined)
  end
end
