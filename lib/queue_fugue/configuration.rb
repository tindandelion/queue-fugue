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
      @next_instrument = ?A
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
    
    def default_counter
      BeatCounter.new(@default_instrument)
    end
    
    def collect_counters
      counters + [default_counter]
    end
    
    def play(instrument, params = {})
      with_next_instrument do |marker|
        @instruments.add_mapping(marker, instrument)
        if params[:default]
          @default_instrument = marker
        else
          @counters << BeatCounter.new(marker, params[:when])
        end
      end
    end
    
    def with_next_instrument(&block)
      block.call(@next_instrument)
      @next_instrument = (@next_instrument.ord + 1).chr
    end
  end
end
