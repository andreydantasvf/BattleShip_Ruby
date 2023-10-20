class BoardSelectedScreen
  attr_accessor :options, :selected_option 
  def initialize
    @title_text = Text.new('BATALHA NAVAL', size: 72, y: 40)
    @title_text.x = (App.class_variable_get(:@@canvas).width - @title_text.width) / 2

    @sub_title = Text.new('SELECIONE O TABULEIRO', size: 32, y: 120)
    @sub_title.x = (App.class_variable_get(:@@canvas).width - @sub_title.width) / 2

    @options = ["Tabuleiro 8x12", "Tabuleiro 10x15"]
    @selected_option = 0

    render
  end

  def render
    @options.each_with_index do |option, index|
      board_option = Text.new(
        option,
        size: 30,
        color: (index == @selected_option) ? 'blue' : 'white'
      )
      board_option.x = (App.class_variable_get(:@@canvas).width - board_option.width) / 2
      board_option.y = (App.class_variable_get(:@@canvas).height - board_option.height + (index * 100)) / 2
    end
  end
end