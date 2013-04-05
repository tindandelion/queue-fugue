require 'jfugue-4.0.3.jar'

class JFugueNotePlayer
  NOTE = 'C'
  
  def play_note
    with_player { |p| p.play NOTE }
  end
  
  def play_rhythm(rhythm_string)
    with_player do |player|
      rhythm = org.jfugue.Rhythm.new
      rhythm.set_layer 1, rhythm_string
      rhythm.add_substitution ?*.ord, '[HAND_CLAP]s'
      rhythm.add_substitution ?!.ord, '[CRYSTAL]s'
      rhythm.add_substitution ?..ord, 'Rs'
      pattern = rhythm.pattern
      pattern.repeat 1
      player.play pattern
    end
  end
  
  private
  
  def with_player(&block)
    player = org.jfugue.Player.new
    block.call(player)
  ensure
    player.close
  end
end
