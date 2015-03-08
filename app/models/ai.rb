class AI
  # basiclly knapstack problem
  # tree width two option take card or not 

  def self.find_take(move,talon) 
    que = [] 
    que << [ [] ,talon.dup,0 ]
    results = []
    while(que.size != 0) 
      node = que.delete_at(0)
      rest = node[1].dup
      nc = rest.delete_at(0)
      if node[2] + nc == move 
        results <<  node[0] + [nc] 
      elsif node[2] + nc < move && rest.size > 0 
        que << [node[0] + [nc],rest,node[2]+nc]
      end 
      if rest.size > 0
        que << [node[0],rest,node[2]] 
      end
    end
    results
  end

end
