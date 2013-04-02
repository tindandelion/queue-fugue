require 'jfugue-4.0.3.jar'

describe "JFugue interface" do
  it 'plays a note' do
    player = org.jfugue.Player.new
    
    note = 'C'
    player.play(note)
  end
  
  it 'plays a sequence of notes' do
    player = org.jfugue.Player.new
    
    notes = 'C B A'
    player.play(notes)
  end
  
  it 'plays notes in a sequence of calls' do
    player = org.jfugue.Player.new
    
    note = 'A'
    3.times { player.play(note) }
  end
end
