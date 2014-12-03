class AccountsController < ApplicationController
  def show
    authorize! :read, @account
  end
end
