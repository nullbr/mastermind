require 'pry'

class Mastermind
  def initialize(player)
    @player = player
    @current_code_guess = []
    @code_gusses = {}
    @guess_count = 1
  end

  def print_rules(rules)
    File.readlines(rules).each{ |line| puts line }
  end

  def generate_code
    @code = []
    while @code.size < 4
      rand_num = rand(1..8)
      @code << rand_num unless @code.any? { |num| num == rand_num }
    end
  end

  def take_a_guess
    @current_code_guess = []
    while @current_code_guess.empty?
      puts "\nTentativa numero #{@guess_count}. Advinhe o codigo secreto: "
      input = gets.chomp
      if input.scan(/\D/).empty? && input.size == 4
        input = input.split('')
        input.each { |digit| @current_code_guess << digit.to_i }
        @guess_count += 1
      elsif input == 'sair'
        abort('Saindo do jogo...')
      else
        puts "Codigo deve conter 4 numeros (ex. 1234) entre 1 e 8. Insira novamente.\n"
      end
    end
  end

  def correction
    correction = []
    @current_code_guess.each_with_index do |guess_num, guess_idx|
      @code.each_with_index do |code_num, code_idx|
        if guess_num.to_i == code_num && guess_idx == code_idx
          correction << 'X'
        elsif guess_num.to_i == code_num
          correction << 'O'
        end
      end
    end
    @code_gusses[@current_code_guess] = correction
  end

  def display_game
    puts "\n"
    @code_gusses.each_with_index do |code, idx|
      idx += 1
      puts "Tentativa #{idx}: #{code}"
    end
  end

  def did_i_win?
    @current_code_guess == @code
  end
end

puts 'Bora jogar, qual é o seu nome?'
player = gets.chomp

game = Mastermind.new(player)
game.print_rules(File.join('regras_user_vs_machine.txt'))
game.generate_code
12.times do
  game.take_a_guess
  game.correction
  game.display_game
  break if game.did_i_win?
end

if game.did_i_win?
  puts "\nParabens #{player}, você venceu a máquina!"
else
  puts "\nNão foi dessa vez, não desista e tente novamente"
end
