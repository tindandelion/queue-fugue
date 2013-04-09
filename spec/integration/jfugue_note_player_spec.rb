require 'jfugue_note_player'

describe "JFugue interface" do
  it 'plays a rhythm' do
    player = JFugueNotePlayer.new
    3.times { player.play_rhythm ['....*.....**...!'] }
  end
  
  it 'plays a rhythm containing several layers' do
    player = JFugueNotePlayer.new
    player.play_rhythm ['.......O........', '....*.....**...!'] 
  end
end
