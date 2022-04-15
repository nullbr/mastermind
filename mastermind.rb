require 'pry'

class Mastermind
  def initialize
    @current_code_guess = []
    @code_gusses = {}
    @guess_count = 1
    @code = []
  end

  def print_rules(rules)
    File.readlines(rules).each { |line| puts line }
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

class UserVsMachine < Mastermind
  def generate_code
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
end

class MachineVsUser < Mastermind
  def secret_code
    while @code.empty?
      puts "\nInsira seu código secreto"
      input = gets.chomp
      if input.split('').uniq.size == 4 && input.to_i != 0
        input.split('').each { |digit| @code << digit.to_i }
      else
        puts 'Insira um código valido, exemplo 1234'
      end
    end
    p @code
  end

  def take_a_guess
    @current_code_guess = []
    while @current_code_guess.empty?
      guess = []
      while guess.size < 4
        rand_num = rand(1..8)
        guess << rand_num unless guess.any? { |num| num == rand_num }
      end
      @current_code_guess = guess unless @code_gusses.any?{ |key, _value| key == guess }
    end
  end
end

game_type = ''
while game_type == ''
  puts 'Escolha o tipo de jogo:'
  puts '1) Tente adivinhar o código secreto gerado pela máquina'
  puts '2) Crie seu próprio codigo secreto e deixe a maquina tentar descobrir'
  input = gets.chomp.to_i
  if [1, 2].include?(input)
    game_type = input
  else
    puts 'Insira opção 1 ou 2'
  end
end

puts 'Bora jogar, qual é o seu nome?'
player = gets.chomp

case game_type
when 1
  game = UserVsMachine.new
  game.print_rules(File.join('regras_user_vs_machine.txt'))
  game.generate_code

  8.times do
    game.take_a_guess
    game.correction
    game.display_game if game_type == 1
    break if game.did_i_win?
  end

  if game.did_i_win?
    puts "\nParabens #{player}, você venceu a máquina!"
  else
    puts "\nNão foi dessa vez, não desista e tente novamente."
  end

when 2
  game = MachineVsUser.new
  game.print_rules(File.join('regras_machine_vs_user.txt'))
  game.secret_code
  count = 1
  while game.did_i_win? == false
    game.take_a_guess
    game.correction
    count += 1
  end

  game.display_game
  puts "#{player.capitalize}, a maquina descobriu seu codigo após #{count} tentativas."
end


