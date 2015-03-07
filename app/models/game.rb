class Game < ActiveRecord::Base
  @@TVALUE = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 13, 14]
  def initialize(num_of_players)
    @num_of_players = num_of_players
    @cards =[]
    52.times do |x|
      @cards << x 
    end  
    @cards.shuffle!
    @moves = []
  end
  def tvalue(card_id)
    @@TVALUE[Card.new(card_id).value_num]
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

  def on_move(move)
    (move - @num_of_players*6 - 4) % 4
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
    puts "WEST  #{s[:south].map {|x| Card.new(x).to_s}.inspect}"
    puts "TABLE  #{s[:talon].map {|x| Card.new(x).to_s}.inspect}"    
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
      hands[on_move(mov)].delete(@moves[mov][0])
      @moves[mov][1].each do |card|
        taken[on_move(mov)] << talon.delete(card)
      end
    end
    st = { :north => hands[0],
           :east => hands[1],
           :south => hands[2],
           :west => hands[3],
           :talon => talon}
    st       
  end
  
  
  def go_game
    deal
    play_move(4,[])
    play_move(5,[])
    print_game
  end
end
