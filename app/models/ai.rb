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
    talons = self.all_talons_11(talon) 
    res = []
    talons.each do |t|
      f = self.find_take1(move,t)
      f.each do |item|
        res << item unless res.include?(item)
      end
    end
    res
  end

  def self.find_take1(move,talon)    
    if move == 1 
      a = self.find_take2(1,talon)
      b = find_take2(11,talon)
      b.each do |item|
        a.push(item) unless a.include?(item)
      end   
      return  a
    else
      return self.find_take2(move,talon)
    end  
  end  
  
  def self.all_talons_11(talon) 
    talons = [] 
    talons << talon
    replaced = []
    talon.each_with_index do |x,i|
      if x == 1 
        t = talon.dup
        t[i] = 11
        talons << t
        replaced.each do |x|
          t = talon.dup
          t[x] = 11
          t[i] = 11
          talons << t
        end  
        replaced << i
      end
    end  
    if talon.select{|x| x==1}.size > 1
      all = talon.dup
      all.each_with_index do |x,i|
        if x == 1 
          all[i] = 11
        end
      end
      talons << all
    end
    talons 
  end
  
  def self.find_take2(move,talon) 
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
        results << indexes unless results.include?(indexes)
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
