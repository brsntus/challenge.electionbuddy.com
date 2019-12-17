class AuditsController < ApplicationController
  def index
    @audits = Audit.includes(:user).all
  end
end
