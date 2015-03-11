class GamesController < ApplicationController
  @@STACKS4 = [ { name: "hand0",
                  type: "V",
                  x: 30,
                  y: 130,
                  dif: 40},
                { name: "hand1",
                  type: "H",
                  x: 400,
                  y: 30,
                  dif: 40},
                { name: "hand2",
                  type: "V",
                  x: 900,
                  y: 130,
                  dif: 40},
               { name: "hand3",
                  type: "H",
                  x: 400,
                  y: 430,
                  dif: 40},
                { name: "talon",
                  type: "H",
                  x: 350,
                  y: 230,
                  dif: 100}]
                              
               
                 
  def show
    @game = Game.new(4,Game.testArray)
    @game.deal
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @game.state }
    end  
  end
  def stacks
    @game = Game.new(4) 
    @stacks = @@STACKS4
    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @stacks}
    end  

  end
end
