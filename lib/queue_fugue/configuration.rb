require 'queue_fugue/instruments'

module QueueFugue
  class Configuration
    attr_reader :counters
    
    def self.read(path)
      instance = self.new
      instance.apply_external(path)
      instance
    end
    
    def initialize
      @instruments = Instruments.new
      @counters = []
      configure_default
    end
    
    def apply_external(path)
      instance_eval(path.read) if path.exist?
    end
    
    def apply_block(&block)
      instance_eval(&block)
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
      instance_eval(&block) if block
      @instruments
    end
    
    def rhythms(&block)
      instance_eval &block
    end
    
    def default_counter
      BeatCounter.new(@default_instrument)
    end
    
    def collect_counters
      counters + [default_counter]
    end
    
    def play(placeholder, params = {})
      @counters << BeatCounter.new(placeholder, params[:when])
    end

    def play_default(instrument)
      @instruments.add_mapping('A', instrument)
      @default_instrument = 'A'
    end
  end
end
