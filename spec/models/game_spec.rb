require 'rails_helper'

arr = [2, 41, 33, 19, 21, 47, 
       24, 36, 37, 27, 5, 0, 
       31, 1, 40, 8, 35, 10, 
       7, 25, 17, 51, 18, 48, 
       44, 42, 45, 4, 
       6, 32, 11, 15, 30, 20, 12, 14, 22, 34, 9, 49, 38, 23, 39, 13, 28, 50, 3, 43, 29, 46, 16, 26]

RSpec.describe Game, :type => :model do

  it "can get array as param" do
    g = Game.new(4,arr) 
    g.deal
    g.print_state
    puts g.state.inspect
  end

  it "can return what to take from talon" do
    g = Game.new(4,arr)
    g.deal
    expect(g.find_take(33)).to eq([[42,4]])
    expect(g.find_take(21)).to eq([[44,42]])
    expect(g.find_take(36)).to eq([[45,4]])
    expect(g.find_take(25)).to eq([[42,45,4]])
  end

end
