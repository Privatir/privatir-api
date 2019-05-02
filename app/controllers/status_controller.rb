class StatusController < ApplicationController
  def index
    render json: { status: :okay }
  end
end
