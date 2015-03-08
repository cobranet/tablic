require 'rails_helper'

arr = [2, 41, 33, 19, 21, 47, 
       24, 36, 37, 27, 5, 0, 
       31, 1, 40, 8, 35, 10, 
       7, 25, 17, 51, 18, 48, 
       44, 42, 45, 4, 
       6, 32, 11, 15, 30, 20, 12, 14, 22, 34, 9, 49, 38, 23, 39, 13, 28, 50, 3, 43, 29, 46, 16, 26]


# At move 1
# NORTH : ["2S", "2C", "7H", "6D", "8D", "8C"]
# EAST : ["JD", "10H", "JH", "AH", "5S", "KC"]
# SOUTH : ["5H", "AS", "AC", "8S", "9H", "10S"]
# WEST  ["7S", "QD", "4D", "QC", "5D", "9C"]
# TABLE  ["5C", "3C", "6C", "4S"]


RSpec.describe Game, :type => :model do

  it "can get array as param" do
    g = Game.new(4,arr) 
    g.deal
    g.state 
  end

  it "can return what to take from talon" do
    g = Game.new(4,arr)
    g.deal
    expect(g.find_take(33)).to eq([[42,4]])
    expect(g.find_take(21)).to eq([[44,42]])
    expect(g.find_take(36)).to eq([[45,4]])
    expect(g.find_take(25)).to eq([[42,45,4]])
  end
  
  it "when player play a card must reduce players hand " do
    g = Game.new(4,arr)
    g.deal
    g.make_play(Card.ids("2S"))
    expect(g.state[:hands][0].size).to eq(5)
    expect(g.state[:talon].size).to eq(5)
    expect(g.on_move).to eq(1)
  end

  it "when player play take a trick his taken stack be increased " do
    g = Game.new(4,arr)
    g.deal
    g.make_play(Card.ids("2S"))
    a = g.find_take(36)[0]
    g.make_play(36,a)
    expect(g.state[:hands][0].size).to eq(5)
  end
  
  it "sum of all score cards must be 22" do
    score = 0
    Game.testArray.each do |card|
      score = Game.score_value(card) + score
    end
    expect(score).to eq(22)
  end

  it "has score function that return score for every player" do
    g = Game.new(4,arr) 
    g.deal
    g.num_of_players.times do |player|
      expect(g.score(player)).to eq(0) 
    end
    g.make_play(41)
    g.make_play(36,g.find_take(36)[0])
    expect(g.score(1)).to eq(1)
  end
end
