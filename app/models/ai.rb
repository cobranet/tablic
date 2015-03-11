class AI
  # basiclly knapstack problem
  # tree width two option take card or not 
  # return possible takes with move

  def self.evaluate(state,player) 
    cards = 0
    tricks = 0
    if  player % 2 == 0 
      sign = 1
    else
      sign = -1
    end
    state[:moves].each do |move| 
        move[1].each do |card| 
          cards = cards + sign
          puts card
          tricks = tricks + Game.score_value(card)*sign
       end
    end
    tricks * 20 + cards 
  end
 
  def self.sum(arr) 
    sum = 0
    arr.each do |x|
      sum = sum + x[0]
    end
    sum
  end   
   
  def self.find_take(move,talon) 
    que = []
    state = []
    talon.each_with_index do |val,index|
      state <<  [val,index]
    end
    que << state
    results = []
    while(que.size != 0) do  
      node = que.delete_at(0)
      # we find sum
      if sum(node) == move 
        indexes = []
        node.each do |c|
          indexes << c[1]
        end
        results << indexes
      end
      # we have more options ... we move one index on time
      if node.size > 1  
        node.each_with_index do |x,i|
          new_node = []
          node.each_with_index do |y,k|
            if k != i 
              new_node << y
            end
          end
          if que.include?(new_node) == false
            que << new_node
          end
        end   
      end
    end
    results
  end

end
