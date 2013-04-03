require 'jfugue-4.0.3.jar'

class JFugueNotePlayer
  NOTE = 'C'
  def initialize
    @player = org.jfugue.Player.new
  end
  
  def play_note
    @player.play(NOTE)
  end
end
