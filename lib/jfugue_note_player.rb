require 'jfugue-4.0.3.jar'

class JFugueNotePlayer
  def play_rhythm(rhythm_strings)
    rhythm = new_rhythm_with_instruments
    add_strings_to_rhythm rhythm, rhythm_strings
    do_play_rhythm(rhythm)
  end
  
  private
  
  def add_strings_to_rhythm(rhythm, strings)
    strings.each_with_index do |ea, i|
      rhythm.set_layer i, ea
    end
  end
  
  def do_play_rhythm(rhythm)
    with_player { |p| p.play rhythm.pattern }
  end
  
  def new_rhythm_with_instruments
    rhythm = org.jfugue.Rhythm.new
    rhythm.add_substitution ?O.ord, '[ACOUSTIC_SNARE]s'
    rhythm.add_substitution ?*.ord, '[BASS_DRUM]s'
    rhythm.add_substitution ?+.ord, '[CRASH_CYMBAL_1]s'
    
    rhythm.add_substitution ?!.ord, '[CRYSTAL]s'
    rhythm.add_substitution ?..ord, 'Rs'
    rhythm
  end
  
  def with_player(&block)
    player = org.jfugue.Player.new
    block.call(player)
  ensure
    player.close
  end
end
