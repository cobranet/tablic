class Game < ActiveRecord::Base
  @@TVALUE = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14]
  attr_accessor :cards

  def initialize(num_of_players,arr=nil)
    @num_of_players = num_of_players
    @cards =[]
    52.times do |x|
      @cards << x 
    end  
    if arr == nil 
      @cards.shuffle!
      puts @cards.inspect
    else
      @cards = arr.dup
    end
    @moves = []
  end

  def self.testArray
    arr = [2, 41, 33, 19, 21, 47, 
       24, 36, 37, 27, 5, 0, 
       31, 1, 40, 8, 35, 10, 
       7, 25, 17, 51, 18, 48, 
       44, 42, 45, 4, 
       6, 32, 11, 15, 30, 20, 12, 14, 22, 34, 9, 49, 38, 23, 39, 13, 28, 50, 3, 43, 29, 46, 16, 26]
  end

  def tvalue(card_id)
    @@TVALUE[Card.new(card_id).value_num]
  end

  def find_take(move) 
    t = state[:talon]
    result = AI.find_take(tvalue(move),t.map {|x| tvalue(x)})
    taken = [] 
    result.each do |res|
      taken << [] 
      res.each do |r|
        t.dup.each do |card_id|
          if tvalue(card_id) == r 
            taken[taken.size-1] << t.delete(card_id)
          end
        end  
      end
    end 
    taken
  end
  
  def deal
    @num_of_players.times do 
      6.times do
        @moves << @cards.delete_at(0)
      end
    end
    4.times do
      @moves << @cards.delete_at(0)
    end
  end

  def play_move(move,take) 
    @moves << [move,take]
  end

  def on_move
    (@moves.size - @num_of_players*6 - 4) % 4
  end
 
  
  def print_game
    @moves.each do |move|
      puts move
    end
    nil
  end
  
  
 
  def print_state
    s = state
    puts "NORTH : #{s[:north].map {|x| Card.new(x).to_s}.inspect}"
    puts "EAST : #{s[:east].map {|x| Card.new(x).to_s}.inspect}"
    puts "SOUTH : #{s[:south].map {|x| Card.new(x).to_s}.inspect}"
    puts "WEST  #{s[:west].map {|x| Card.new(x).to_s}.inspect}"
    puts "TABLE  #{s[:talon].map {|x| Card.new(x).to_s}.inspect}"    
  end
  
  def self.test
    g = Game.new(4)
    g.deal
    puts g.state
    g.print_state
    g
  end

  def state
    hands = [] 
    talon = []
    taken = []
    mov = 0
    @num_of_players.times do |i|
      hands[i] = []
      6.times do |x|
        hands[i] << @moves[mov]
        mov = mov + 1
      end
    end
    4.times do |i|
      talon << @moves[mov] 
      mov = mov + 1
    end
    while (mov < @moves.size  && mov < 2*@num_of_players*6 + 4  ) do
      hands[on_move].delete(@moves[mov][0])
      @moves[mov][1].each do |card|
        taken[on_move] << talon.delete(card)
      end
    end
    st = { :north => hands[0],
           :east => hands[1],
           :south => hands[2],
           :west => hands[3],
           :talon => talon}
    st       
  end
  
  
end
