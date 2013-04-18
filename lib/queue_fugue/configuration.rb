require 'queue_fugue/instruments'

module QueueFugue
  class Configuration
    attr_reader :instruments
    
    def self.read(path)
      instance = self.new
      instance.apply_external(path)
      instance
    end
    
    def initialize
      @instruments = Instruments.new
      @counters = []
      @next_instrument = ?A
      @scale_factor = 1
    end
    
    def apply_external(path)
      instance_eval(path.read) if path.exist?
    end
    
    def apply_block(&block)
      instance_eval(&block)
    end
    
    def counters
      if @default_instrument
        @counters + [new_counter(@default_instrument)]
      else
        @counters
      end
    end
    
    def background_beat_string
      @background_beat_string
    end
    
    def play(instrument, params = {})
      with_next_instrument do |marker|
        @instruments.add_mapping(marker, instrument)
        if params[:default]
          @default_instrument = marker
        else
          counter = new_counter(marker)
          counter.filter_by &params[:when]
          @counters << counter
        end
      end
    end
    
    def background_beat(beat_string, substitutions = {})
      @background_beat_string = beat_string
      substitutions.each_pair { |marker, instr| @instruments.add_mapping(marker, instr) }
    end
    
    def scale_factor(value)
      @scale_factor = value
    end
    
    private
    
    def with_next_instrument(&block)
      block.call(@next_instrument)
      @next_instrument = (@next_instrument.ord + 1).chr
    end

    def new_counter(marker)
      counter = BeatCounter.new(marker)
      counter.scale_by @scale_factor
      counter
    end
  end
end
