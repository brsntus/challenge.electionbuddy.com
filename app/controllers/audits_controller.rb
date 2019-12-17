class AuditsController < ApplicationController
  def index
    @audits = Audit.includes(:user).all.order(created_at: :desc)
  end
end
