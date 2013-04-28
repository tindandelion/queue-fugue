require 'queue_fugue/log4j-1.2.17.jar'
require 'queue_fugue/jfugue-4.1.0-SNAPSHOT.jar'

describe "JFugue working with rhythms" do
  let(:player) { org.jfugue.Player.new }
  
  it 'plays a rhythm' do
    rhythm = org.jfugue.Rhythm.new
    
    rhythm.set_layer(1, 'O..oO...O..oOO..')
    rhythm.set_layer(2, "..*...*...*...*.");
    rhythm.set_layer(3, "^^^^^^^^^^^^^^^^");
    rhythm.set_layer(4, "...............!");
    
    rhythm.add_substitution(?O.ord, "[BASS_DRUM]i");
    rhythm.add_substitution(?o.ord, "Rs [BASS_DRUM]s");
    rhythm.add_substitution(?*.ord, "[ACOUSTIC_SNARE]i");
    rhythm.add_substitution(?^.ord, "[PEDAL_HI_HAT]s Rs");
    rhythm.add_substitution(?..ord, "Ri");
    rhythm.addSubstitution(?!.ord, "[CRASH_CYMBAL_1]s Rs");
    
    pattern = rhythm.get_pattern
    pattern.repeat(4)
    player.play(pattern)
  end
  
  it 'plays a rhythm' do
    rhythm = org.jfugue.Rhythm.new
    
    rhythm.set_layer(1, "................*");
    rhythm.set_layer(4, "........!........");
    rhythm.add_substitution(?*.ord, "[ACOUSTIC_SNARE]s");
    rhythm.add_substitution(?..ord, "Rs");
    rhythm.addSubstitution(?!.ord, "[CRASH_CYMBAL_1]s");
    
    pattern = rhythm.get_pattern
    start = Time.now
    player.play(pattern)
    player.play(pattern)
    player.play(pattern)
    player.play(pattern)
    player.close
  end
  
end

