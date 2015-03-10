class GamesController < ApplicationController
  def show
    @game = Game.new(4,Game.testArray)
    @game.deal
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @game.state }
    end  
  end
end
