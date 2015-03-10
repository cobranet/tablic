class Game < ActiveRecord::Base
  @@TVALUE = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14]
  
  attr_accessor :cards,:moves, :num_of_players,:hands,:talon

  def initialize(num_of_players,arr=nil)
    @num_of_players = num_of_players
    @cards =[]
    @hands = []
    @talon = []
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

  def self.score_value(card) 
    if [10,12,13,14,1].include?(self.tvalue(card)) && Card.new(card).to_s != "TD" 
      return 1
    elsif Card.new(card).to_s == "2C" 
      return 1
    elsif Card.new(card).to_s == "TD"
      return 2
    else
      return 0
    end
  end
  
  def score(player) 
    score = 0
    state[:taken][player].each do |c| 
      score = score + Game.score_value(c) 
    end
    score
  end
  
  def self.testArray
    arr = [2, 41, 33, 19, 21, 47, 
       24, 36, 37, 27, 5, 0, 
       31, 1, 40, 8, 35, 10, 
       7, 25, 17, 51, 18, 48, 
       44, 42, 45, 4, 
       6, 32, 11, 15, 30, 20, 12, 14, 22, 34, 9, 49, 38, 23, 39, 13, 28, 50, 3, 43, 29, 46, 16, 26]
    arr.dup
  end

  def Game.tvalue(card_id)
    @@TVALUE[Card.new(card_id).value_num]
  end

  def find_take(move) 
    t = state[:talon]
    result = AI.find_take(Game.tvalue(move),t.map {|x| Game.tvalue(x)})
    taken = [] 
    result.each do |res|
      taken << [] 
      res.each do |r|
        t.each do |index_of_card|
          taken[taken.size-1] << t.delete_at(index_of_card)
        end  
      end
    end 
    taken
  end
  
  def deal
    @num_of_players.times do |player|
      @hands << [] 
      6.times do
        @hands[player] << @cards.delete_at(0)
      end
    end
    4.times do
      @talon << @cards.delete_at(0)
    end
    self
  end

  def make_play(move,take=[]) 
    if take.size != 0
      arr  = take + [move]
    else
      arr  = take
    end
    @moves << [move,arr]
  end

  def on_move
    (@moves.size) % 4
  end
 
  
  def print_game
    @moves.each do |move|
      puts move
    end
    nil
  end
  
  
 
  def print_state
    s = state
    @num_of_players.times do |player| 
      puts "PLAYER:[#{player}] : #{s[:hands][player].map {|x| Card.new(x).to_s}.inspect}"
      puts "TAKEN : #{s[:taken][player].map { |x| Card.new(x).to_s}.inspect}" 
    end
    puts "TABLE  #{s[:talon].map {|x| Card.new(x).to_s}.inspect}"    
  end

  
  def self.test
    g = Game.new(4,Game.testArray)
    g.deal
    puts g.state
    g.print_state
    g
  end

  def who_was_on_move(move) 
    (move - @num_of_players*6 - 4) % 4
  end
  
  def state_for_player(player) 
    st = {
      :hand => @hands[player].dup,
      :moves => @moves.dup,
      :talon => @talon.dup
    }
    st
  end
  
  def state
    hands = [] 
    talon = []
    taken = []
    mov = 0
    @num_of_players.times do |i|
      hands[i] = @hands[i].dup
      taken[i] = []
    end
    talon = @talon.dup

    while (mov < @moves.size)  do
      talon << @moves[mov][0]
      a = hands[who_was_on_move(mov)].delete(@moves[mov][0])
      @moves[mov][1].each do |card|
        taken[who_was_on_move(mov)] << talon.delete(card)
      end
      mov = mov + 1
    end
    st = { :hands => hands.dup,
           :talon => talon.dup,
           :taken => taken.dup,
           :moves => @moves.dup}
    st       
  end
  
end
