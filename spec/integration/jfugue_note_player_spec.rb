require 'jfugue_note_player'
require 'instruments'

describe "JFugue interface" do
  let(:instruments) {
    value = Instruments.new
    value.add_mapping '*', 'BASS_DRUM'
    value.add_mapping 'O', 'ACOUSTIC_SNARE'
    value
  }
  
  it 'plays a rhythm' do
    player = JFugueNotePlayer.new(instruments)
    3.times { player.play_rhythm ['....*.....**...!'] }
  end
  
  it 'plays a rhythm containing several layers' do
    player = JFugueNotePlayer.new(instruments)
    player.play_rhythm ['.......O........', '....*.....**...!'] 
  end
end
