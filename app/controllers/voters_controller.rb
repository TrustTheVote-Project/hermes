class VotersController < ApplicationController
  before_action :set_voter, only: [:show, :update, :destroy]
  before_action :authenticate

  # GET /voters
  def index
    @voters = Voter.all

    render json: @voters
  end

  # GET /voters/1
  def show
    render json: @voter
  end

  # POST /voters
  def create
    @voter = Voter.new(voter_params)

    if @voter.save
      render json: @voter, status: :created, location: @voter
    else
      render json: @voter.errors, status: :unprocessable_entity
    end
  end

  def import
    Voter.import_from_csv(request.body)
  rescue InvalidVoterException => e
    render text: e.message, status: 422
  end

  # PATCH/PUT /voters/1
  def update
    if @voter.update(voter_params)
      render json: @voter
    else
      render json: @voter.errors, status: :unprocessable_entity
    end
  end

  # DELETE /voters/1
  def destroy
    @voter.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_voter
      @voter = Voter.find(params[:id])
    end

    # Only allow a trusted parameter "allow list" through.
    def voter_params
      params.require(:voter).permit(:fist_name, :last_name, :address, :birth_date, :state, :city, :zip, :registaration_status, :permanent_absentee, :file)
    end
end
