require 'testable_player'
require 'instruments'

describe "JFugue interface" do
  let(:instruments) {
    value = Instruments.new
    value.add_mapping '*', 'BASS_DRUM'
    value.add_mapping 'O', 'ACOUSTIC_SNARE'
    value
  }
  
  context 'with testable player' do
    
    let(:player) { TestablePlayer.new(instruments) }
    
    it 'plays a rhythm with instument substitutions' do
      player.play_rhythm ['..*..']
      player.should played_music_string('V9 L0 Rs Rs [BASS_DRUM]s Rs Rs ')
    end
    
    it 'plays a rhythm containing several layers' do
      player.play_rhythm ['..O..', '..*..']
      player.should played_music_string('V9 L0 Rs Rs [ACOUSTIC_SNARE]s Rs Rs ' +
                                        'L1 Rs Rs [BASS_DRUM]s Rs Rs ')
    end
  end
  
  context 'with real player' do
    
    let(:player) { JFuguePlayer.new(instruments) }
    
    it 'plays a rhythm' do
      lambda {
        player = JFuguePlayer.new(instruments)
        3.times { player.play_rhythm ['....*.....**...!'] }
      }.should_not raise_error
    end
  end
end
