class ApplicationController < ActionController::Base
  before_action :set_current_user

  private

  def set_current_user
    User.current_user = current_user
  end
end
