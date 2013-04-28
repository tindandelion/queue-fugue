require 'queue_fugue/log4j-1.2.17.jar'
require 'queue_fugue/jfugue-4.1.0-SNAPSHOT.jar'

module QueueFugue
  class JFuguePlayer
    def initialize(instruments)
      @instruments = instruments
      @player = org.jfugue.Player.new(true, true)
    end
    
    def play_rhythm(rhythm_strings)
      rhythm = new_rhythm_with_instruments
      add_strings_to_rhythm rhythm, rhythm_strings
      do_play_rhythm(rhythm)
    end
    
    def close!
      @player.sequencer.close
    end
    
    protected
    
    def with_player(&block)
      block.call(@player)
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
      @instruments.apply_to(rhythm)
      rhythm
    end
  end
end
