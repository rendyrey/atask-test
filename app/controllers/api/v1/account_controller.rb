# frozen_string_literal: true

class Api::V1::AccountController < ApplicationController
  skip_before_action :authenticate_user, only: [ :create ]

  def get
    page_param = params[:page] || 1
    if page_param.blank?
      render json: { error: true, message: "Page parameter is required" }, status: :unprocessable_entity
    end

    per_page = params[:per_page] || 10

    @accounts = Account.page(page_param).per(per_page)
    current_page = @accounts.current_page
    total_pages = @accounts.total_pages

    render json: {
      meta: {
        total_pages: total_pages,
        current_page: current_page,
        next_page: next_page_link(current_page, total_pages, per_page),
        prev_page: prev_page_link(current_page, per_page),
        total_count: @accounts.total_count
      },
      data: @accounts
    }, status: :ok
  end

  def show
    wallets = @current_user.wallets.includes(:entity)
    render json: @current_user.as_json(except: :password_digest).merge(wallets: wallets), status: :ok
  end

  def create
    begin
      @account = Account.create!(account_params)

      render json: { error: false, message: "Account created successfully", account: @account.as_json(except: :password_digest) }, status: :created
    rescue => e
      render json: { error: true, message: e.message }, status: :unprocessable_entity
    end
  end

  def account_balance
    begin
      recalculate_balance
      balance_info = @current_user.wallets.includes(:entity).map do |wallet|
        {
          wallet_entity: wallet.entity.entity_name,
          wallet_balance: wallet.balance.to_f
        }
      end

      render json: { error: false, balance_info: balance_info }, status: :ok
    rescue => e
      render json: { error: true, message: e.message }, status: :unprocessable_entity
    end
  end

  def account_wallets
    render json: @current_user.wallets.as_json(only: [:id, :entity_id, :balance]), status: :ok
  end

  private

    def account_params
      params.permit(:name, :email, :password)
    end

    def recalculate_balance
      @current_user.wallets.each { |wallet| wallet.update_balance }
    end

    def find_user
      @account = Account.find(params[:id])
    end

    def next_page_link(current_page, total_pages, per_page)
      return nil if current_page >= total_pages

      url_for(controller: controller_name, action: action_name, page: current_page + 1, per_page: per_page)
    end

    def prev_page_link(current_page, per_page)
      return nil if current_page <= 1

      url_for(controller: controller_name, action: action_name, page: current_page - 1, per_page: per_page)
    end
end
