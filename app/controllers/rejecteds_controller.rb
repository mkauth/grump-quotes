class RejectedsController < ApplicationController
  before_action :set_rejected, only: [:show, :edit, :update, :destroy]

  # GET /rejecteds
  # GET /rejecteds.json
  def index
    @rejecteds = Rejected.all
  end

  # GET /rejecteds/1
  # GET /rejecteds/1.json
  def show
  end

  # GET /rejecteds/new
  def new
    @rejected = Rejected.new
  end

  # GET /rejecteds/1/edit
  def edit
  end

  # POST /rejecteds
  # POST /rejecteds.json
  def create
    @rejected = Rejected.new(rejected_params)

    respond_to do |format|
      if @rejected.save
        format.html { redirect_to @rejected, notice: 'Rejected was successfully created.' }
        format.json { render :show, status: :created, location: @rejected }
      else
        format.html { render :new }
        format.json { render json: @rejected.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rejecteds/1
  # PATCH/PUT /rejecteds/1.json
  def update
    respond_to do |format|
      if @rejected.update(rejected_params)
        format.html { redirect_to @rejected, notice: 'Rejected was successfully updated.' }
        format.json { render :show, status: :ok, location: @rejected }
      else
        format.html { render :edit }
        format.json { render json: @rejected.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rejecteds/1
  # DELETE /rejecteds/1.json
  def destroy
    @rejected.destroy
    respond_to do |format|
      format.html { redirect_to rejecteds_url, notice: 'Rejected was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rejected
      @rejected = Rejected.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rejected_params
      params.require(:rejected).permit(:name)
    end
end
