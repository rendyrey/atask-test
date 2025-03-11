class EverydayJob < ApplicationJob
  queue_as :default

  def perform(*args)
    accounts = Account.all
    accounts.each do |account|
      account.update_balance
    end
  end
end
