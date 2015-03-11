class GamesController < ApplicationController
  def show
    @game = Game.new(4)
    @game.deal
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @game.state }
    end  
  end
  def stacks
    @game = Game.new(4) 
    @stacks = []
    @game.num_of_players.times do |player|
      @stacks << { name: "hand#{player}" ,
                    type: "V",
                    x: 30 + 100*player,
                    y: 30,
                    dif: 40}
    end
    @stacks <<  { name: "talon" ,
                    type: "H",
                    x: 500,
                    y: 30,
                    dif: 40}
    @stacks
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @stacks}
    end  

  end
end
