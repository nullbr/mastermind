require 'pry'

class Mastermind
  def initialize(player)
    @player = player
    @code = []
    @code_gusses = []
    @correction = []
  end

  def generate_code
    while @code.size < 4
      rand_num = rand(0..8)
      unless @code.any?{ |num| num == rand_num }
        @code << rand_num
      end
    end
    p @code
  end

  def take_a_guess(current_code_guess)
    current_code_guess = current_code_guess.split('')
    if current_code_guess.size == 4
      @current_code_guess = current_code_guess.uniq
    end
    p @current_code_guess
  end

  def correction
    @current_code_guess.each_with_index do |guess_num, guess_idx|
      @code.each_with_index do |code_num, code_idx|        
        if guess_num.to_i == code_num && guess_idx == code_idx
          @correction << 2
        elsif guess_num.to_i == code_num
          @correction << 1
        end
      end
    end
    p @correction
  end
end

game = Mastermind.new('bruno')
game.generate_code
game.take_a_guess("1342")
game.correction
