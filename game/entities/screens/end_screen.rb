class EndScreen
  def initialize(win, top_scores)
    @width_canvas = App.class_variable_get(:@@canvas).width
    if win == :player

      @win_text = Text.new('VOCE VENCEU !', size: 64, y: 40)
      @win_text.x = (@width_canvas - @win_text.width) / 2
    else
      @win_text = Text.new('VOCE PERDEU :(', size: 64, y: 40)
      @win_text.x = (@width_canvas - @win_text.width) / 2
    end

    @ranking_text = Text.new('TOP 5 Players', size: 26, y: 200)
    @ranking_text.x = (@width_canvas - @ranking_text.width) / 2

    top_scores.each_with_index do |score, index|
      score = "Nome: #{score[:player_name]}, Pontuação: #{score[:score]}, Data/Horário: #{score[:created_at]}"
      score_text = Text.new(score, size: 26, y: 240 + (index * 80))
      score_text.x = (@width_canvas - score_text.width) / 2
    end
  end
end