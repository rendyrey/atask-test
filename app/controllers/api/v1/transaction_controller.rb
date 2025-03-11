# frozen_string_literal: true

class Api::V1::TransactionController < ApplicationController
  def create
    begin
      raise "Invalid transaction" unless Transaction.valid_transaction?(@current_user, params)

      Transaction.create(transaction_params.merge({ transaction_date_time: Time.now }))

      render json: { error: false, message: "Success" }, status: :created
    rescue => e
      render json: { error: true, message: e.message }, status: :unprocessable_entity
    end
  end

  def top_up
    begin
      is_valid, message = Transaction.valid_top_up?(top_up_params)
      raise message unless is_valid

      Transaction.create!({
        target_wallet_id: top_up_params[:wallet_id],
        amount: top_up_params[:amount],
        transaction_type: :credit,
        transaction_date_time: Time.now
      })

      render json: { error: false, message: "Success Top-up" }, status: :created
    rescue => e
      render json: { error: true, message: e.message }, status: :unprocessable_entity
    end
  end

  def withdraw
    begin
      is_valid, message = Transaction.valid_withdraw?(@current_user, withdraw_params)
      raise message unless is_valid

      Transaction.create!({
        source_wallet_id: params[:wallet_id],
        amount: params[:amount],
        transaction_type: :debit,
        transaction_date_time: Time.now
      })

      render json: { error: false, message: "Success Withdraw" }, status: :created
    rescue => e
      render json: { error: true, message: e.message }, status: :unprocessable_entity
    end
  end

  def transfer
    begin
      is_valid, message = Transaction.valid_transfer?(@current_user, transfer_params)
      raise message unless is_valid

      Transaction.create({
        source_wallet_id: params[:source_wallet_id],
        target_wallet_id: params[:target_wallet_id],
        amount: params[:amount],
        transaction_type: :transfer,
        transaction_date_time: Time.now
      })

      render json: { error: false, message: "Success Transfer" }, status: :created
    rescue => e
      render json: { error: true, message: e.message }, status: :unprocessable_entity
    end
  end

  private
    def top_up_params
      params.require([ :wallet_id, :amount ])
      params.permit(:wallet_id, :amount)
    end

    def withdraw_params
      params.require([ :wallet_id, :amount ])
      params.permit(:wallet_id, :amount)
    end

    def transfer_params
      params.require([ :source_wallet_id, :target_wallet_id, :amount ])
      params.permit(:source_wallet_id, :target_wallet_id, :amount)
    end
end
