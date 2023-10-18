require 'ruby2d'

class Menu
  attr_reader :start_selected

  def initialize(window)
    @window = window
    @options = ["Iniciar", "Sair"]
    @selected_option = 0
    @start_selected = false
  end

  def handle_input(event)
    if event.key == 'w' && @selected_option > 0
      @selected_option -= 1
    elsif event.key == 's' && @selected_option < @options.length - 1
      @selected_option += 1
    elsif event.key == 'return' || event.key == 'enter'
      case @options[@selected_option]
      when "Iniciar"
        # Lógica para iniciar o jogo
        puts "Iniciar o jogo"
        @start_selected = true  # Marcar que "Iniciar" foi selecionado
      when "Sair"
        puts "Sair do jogo"
        @window.close
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
end