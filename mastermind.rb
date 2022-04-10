class Mastermind
  def initialize(player)
    @player = player
    @current_guess = [1, 2, 3, 4]
    @correction = ["right", "almost"]
    @gusses = {}
    @colors = %w[vermelho azul verde amarelo marrom laranja preto branco]
  end

  def color_choices
    colors_size = @colors.length - 1
    @colors.each_with_index do |color, idx|
      if idx == colors_size
        print "#{color}\n"
      else
        print "#{color} | "
      end
    end
    puts "    1    |   2  |   3   |    4    |    5   |    6    |   7   |    8"
  end

  def display_game
    puts "#{@current_guess} #{@correction}"
  end
end

game = Mastermind.new('bruno')
game.color_choices
game.display_game
