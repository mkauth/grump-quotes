class QuotesController < ApplicationController
  before_action :set_quote, only: [:show, :edit, :update, :destroy]

  # GET /quotes
  # GET /quotes.json
  def index
    @quotes = Quote.all
  end

  # GET /quotes/1
  # GET /quotes/1.json
  def show
  end

  # GET /quotes/new
  def new
    @quote = Quote.new
	@showlist = Episode.select(:show).distinct
  end

  # GET /quotes/1/edit
  def edit
  end

  # POST /quotes
  # POST /quotes.json
  def create
	episode = Episode.find_by(game: params[:game], part: params[:part])
    @quote = episode.quotes.new(content: params[:quote][:content], time: params[:quote][:time])

    respond_to do |format|
      if @quote.save
        format.html { redirect_to @quote, notice: 'Quote was successfully created.' }
        format.json { render :show, status: :created, location: @quote }
      else
        format.html { render :new }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /quotes/1
  # PATCH/PUT /quotes/1.json
  def update
    respond_to do |format|
      if @quote.update(quote_params)
        format.html { redirect_to @quote, notice: 'Quote was successfully updated.' }
        format.json { render :show, status: :ok, location: @quote }
      else
        format.html { render :edit }
        format.json { render json: @quote.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /quotes/1
  # DELETE /quotes/1.json
  def destroy
    @quote.destroy
    respond_to do |format|
      format.html { redirect_to quotes_url, notice: 'Quote was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  def get_games
	show_name = params[:show_name]
	@games = Episode.select(:game).distinct.where(show: show_name).order(:game)
	respond_to do |format|
		format.json {render json: @games}
	end
  end
  def get_parts
	game_name = params[:game_name]
	@parts = Episode.select(:part).where(game: game_name)
	respond_to do |format|
		format.json {render json: @parts}
	end
  end

  def search
	@quotes = Quote.where(["content like ?","%#{params[:search]}%"])
	render 'quotes/search_results'
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_quote
      @quote = Quote.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def quote_params
      params.require(:quote).permit(:content, :episode_id, :time)
    end
end
