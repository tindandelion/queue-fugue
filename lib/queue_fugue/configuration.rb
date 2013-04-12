require 'queue_fugue/instruments'

module QueueFugue
  class Configuration
    def self.read(path)
      instance = self.new
      instance.apply_external(path)
      instance
    end
    
    def initialize
      @instruments = Instruments.new
      configure_default
    end
    
    def apply_external(path)
      instance_eval(path.read) if path.exist?
    end
    
    def apply_block(&block)
      instance_eval(&block)
    end
    
    def configure_default
      default_instrument 'O'
      
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
    
    def default_instrument(*args)
      @default_instrument = args.first unless args.empty?
      @default_instrument
    end

    def play(placeholder, params = {})
    end
  end
end
