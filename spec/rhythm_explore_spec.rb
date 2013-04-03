require 'jfugue-4.0.3.jar'

describe "JFugue working with rhythms" do
  it 'plays a rhythm' do
    rhythm = org.jfugue.Rhythm.new
    player = org.jfugue.Player.new
    
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
  
end

