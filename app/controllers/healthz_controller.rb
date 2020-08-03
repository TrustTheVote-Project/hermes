class HealthzController < ApplicationController
    def index
      render json: {healthy: true}
    end
end