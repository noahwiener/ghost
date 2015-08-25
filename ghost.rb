
require 'set'

class Game
  attr_accessor :fragment, :current_player, :previous_player, :players

  def initialize(players, dictionary = "ghost-dictionary.txt")
    @players = players
    @current_player = players[0]
    @previous_player = players.last
    @dictionary = read_dictionary(dictionary)
    @fragment = ""
    @record = {}
    @ghost_hash = { 5 => "GHOST", 4 => "GHOS", 3 => "GHO", 2 => "GH", 1 => "G", 0 => ""}
    set_record
  end

  def set_record
    @players.each do |player|
      @record[player] = 0
    end
  end

  def inspect
    {current_player: @current_player}.to_s
  end

  def display_standings
    @record.each do |player, losses|
      puts "#{player.name} : #{@ghost_hash[losses]}"
    end
  end

  def run
    until @record.values.include?(5)
      display_standings
      play_round
      @fragment = ""
      @record[@previous_player] += 1
    end
    display_standings
  end

  def read_dictionary(dictionary)
    dict = Set.new
    File.foreach(dictionary) { |line| dict << line.strip }
    dict
  end

  def play_round
    until won?
      puts "#{@current_player.name} should add a letter to \"#{@fragment}\""
      take_turn
      next_player!
    end
    puts "#{@current_player.name} won after #{@previous_player.name} finished the word #{@fragment}"
  end

  def won?
    @dictionary.include?(@fragment)
  end

  def next_player!
    current_player_index = @players.index(@current_player)
    if current_player_index == @players.size - 1
      @current_player = @players[0]
      @previous_player = @players[-1]
    else
      @current_player = @players[current_player_index + 1]
      @previous_player = @players[current_player_index]
    end
  end

  def take_turn
    word_to_check = @fragment + current_player.guess
    if valid_play?(word_to_check)
      @fragment = word_to_check
    else
      current_player.alert_invalid_guess
      take_turn
    end
  end

  def valid_play?(string)
    @dictionary.each do |word|
      if word[0...string.length] == string
        return true
      end
    end
    false
  end



end

class Player
  attr_accessor :name, :game_losses, :game_record
  def initialize(name)
    @name = name
  end

  def guess
    puts "Guess a letter"
    letter = gets.chomp
  end

  def alert_invalid_guess
    puts "invalid guess"
  end
end
