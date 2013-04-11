require 'queue_fugue/instruments'

module QueueFugue
  class Configuration
    def self.read(path)
      instance = self.new
      instance.apply_external(path)
      instance
    end
    
    def initialize(player_class)
      @player_class = player_class
      @instruments = Instruments.new
      configure_default
    end
    
    def apply_external(path)
      instance_eval(path.read) if path.exist?
    end
    
    def configure_default
      map '*', to:'BASS_DRUM'
      map 'O', to: 'ACOUSTIC_SNARE'
      map '+', to: 'CRASH_CYMBAL_1'
    end
    
    def map(placeholder, params = {to: ''})
      @instruments.add_mapping(placeholder, params[:to])
    end
    
    def instruments(&block)
      block.call(self) if block
      @instruments
    end
    
    def create_player
      @player_class.new(instruments)
    end
  end
end
