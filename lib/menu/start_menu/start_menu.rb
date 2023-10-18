class StartMenu
  attr_reader :show_game
  
  def initialize(window)
    @window = window
    @options = ["Tabuleiro 8x12", "Tabuleiro 10x15"]
    @selected_option = 0
    @visible = false
    @show_game = false
  end

  def handle_input(event)
    if event.key == 'w' && @selected_option > 0
      @selected_option -= 1
    elsif event.key == 's' && @selected_option < @options.length - 1
      @selected_option += 1
    elsif event.key == 'return' || event.key == 'enter'
      case @options[@selected_option]
      when "Tabuleiro 8x12"
        # Lógica para iniciar o jogo com tabuleiro 8x12
        puts "Iniciar jogo com tabuleiro 8x12"
        @show_game = true
        # Não defina a variável "finished"
      when "Tabuleiro 10x15"
        # Lógica para iniciar o jogo com tabuleiro 10x15
        puts "Iniciar jogo com tabuleiro 10x15"
        @show_game = true
        # Não defina a variável "finished"
      end
    end
  end

  def render
    @window.clear
    @options.each_with_index do |option, index|
      Text.new(
        option,
        x: 300,
        y: 200 + (index * 50),
        size: 30,
        color: (index == @selected_option) ? 'blue' : 'white'
      )
    end
  end

  def visible
    @visible
  end
end